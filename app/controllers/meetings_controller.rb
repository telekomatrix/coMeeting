class MeetingsController < ApplicationController
  before_filter :authenticate, :only => [:index]

  def index
    @meetings = Meeting.order('created_at DESC').paginate(:page => params[:page], :per_page => 20)
  end


  def show
    @participation = Participation.find_by_link(params[:id])
    if @participation.nil?
      flash[:error] = t("meeting.controller.show.error.notfound")
      redirect_to root_path
    else
      @meeting = @participation.meeting
      @minutes = @meeting.minutes
      @static_minutes = @meeting.static_minutes
    end
  end


  def new
    @meeting = Meeting.new
    @creator = User.new
  end


  def create
    params[:meeting][:topics].reject!( &:blank?)
    params[:meeting][:topics].reject! { |s| s == 'add a new topic here' }
    params[:participants].reject! { |s| s == 'add a new participant here' }

    @meeting = Meeting.new(params[:meeting])
    # maybe you need @creator here

    if @meeting.valid?
      
      @creator = User.find_or_new(params[:creator][:email], params[:creator][:name])

      if @creator.valid?
        @meeting.save
        @creator.save
        cp = @meeting.participations.new(:user_id => @creator.id, :is_attending => 1)
        cp.is_creator = true
        cp.is_admin = true
        cp.save

        params[:participants].each do |email|
          unless email.blank?
            user = User.find_or_create_by_email(email)
            participation = @meeting.participations.create(:user_id => user.id)
            UserMailer.invite(@creator.name_formatted, participation).deliver
          end
        end

        if @creator.email.blank?
          redirect_to meeting_path(cp.link), notice: t("meeting.controller.create.notice.withoutauth")
        else
          UserMailer.authenticate(cp).deliver
          redirect_to root_path, notice: t("meeting.controller.create.notice.withauth")
        end
      else
        flash[:error] = t("meeting.controller.create.error.notcreated")
        render "static/home"
      end
    else
      flash[:error] = t("meeting.controller.create.error.notcreated")
      render "static/home"
    end
  end


  def edit
    @participation = Participation.find_by_link(params[:id])
    if @participation.nil?
      flash[:error] = t("meeting.controller.edit.error.notfound")
      redirect_to root_path
    elsif @participation.is_admin
      @meeting = @participation.meeting
    else
      flash[:error] = t("meeting.controller.edit.error.notauthorized")
      redirect_to root_path
    end
  end
    
    
  def update
    participation = Participation.find_by_link(params[:id])
    if participation.nil?
      flash[:error] = t("meeting.controller.update.error.notfound")
      redirect_to root_path
    elsif !participation.is_admin
      flash[:error] = t("meeting.controller.update.error.notauthorized")
      redirect_to root_path
    else
      @meeting = participation.meeting

      admin_name = participation.user.name_formatted

      params[:meeting][:topics].reject!( &:blank? )
      params[:participants].reject!( &:blank? )
      params[:meeting][:topics].reject! { |s| s == 'add a new topic here' }
      params[:participants].reject! { |s| s == 'add a new participant here' }

      @meeting.participations.each do |participation|
        unless params[:participants].include?(participation.user.email)
          participation.destroy
        end
      end

      params[:participants].each do |email|
        up = @meeting.find_participation_by_email(email)
        if up.nil?
          user = User.find_or_create_by_email(email)
          up = @meeting.participations.create(:user_id => user.id)
          UserMailer.invite(admin_name, up).deliver
        end
      end

      if @meeting.update_attributes(params[:meeting])
        redirect_to meeting_path(participation.link), notice: t("meeting.controller.update.notice")
      else
        flash[:error] = t("meeting.controller.update.error.notupdated")
        render action: "edit"
      end
    end
  end


  def destroy
    participation = Participation.find_by_link(params[:id])
    if participation.nil?
      flash[:error] = t("meeting.controller.destroy.error.notfound")
      redirect_to root_path
    elsif participation.is_admin
      participation.meeting.destroy
      flash[:notice] =  t("meeting.controller.destroy.notice")
      if params[:goto] == "index"
        redirect_to meetings_path
      else
        redirect_to root_path
      end
    else
      flash[:error] = t("meeting.controller.destroy.error.notauthorized")
      redirect_to root_path
    end
  end


  def update_minutes
    participation = Participation.find_by_link(params[:id])

    if !participation.nil? && participation.is_creator
      participation.meeting.update_attribute(:minutes, params[:minutes])
    end

    render :nothing => true
  end


  def show_minutes
    participation = Participation.find_by_link(params[:id])

    unless participation.nil?
      @minutes = participation.meeting.minutes
    else
      render :nothing => true
    end
  end


  def download_pdf
    participation = Participation.find_by_link(params[:id])

    unless participation.nil?
      my_file = "tmp/minutes_#{SecureRandom.urlsafe_base64(10)}.pdf"
      Prawn::Document.generate(my_file) do
        text participation.meeting.minutes_to_pdf
      end
      send_file my_file
    end
  end

  # def update_action_item
  #   participation = Participation.find_by_id(params[:id])

  #   participation.update_attributes(:action_item => params[:action_item], :deadline => params[:deadline])
        
  #   @static_minutes = participation.meeting.static_minutes

  #   respond_to do |format|
  #    format.js
  #   end
  #   # render :js ?
  #   # Aqui não é preciso meter respond_to nem render :js. Isto vai automaticamente ao ficheiro com o nome desta action
  # end

end