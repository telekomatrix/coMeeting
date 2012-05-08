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

      # if @meeting.verified == false
      #   @meeting.participations.each do |participation|
      #     UserMailer.email(participation.user.email, t("email.participant.subject", :admin => name), t("email.participant.body", :link => "#{ENV['HOST']}/#{params[:locale]}/meetings/#{participation.link}") ).deliver
      #   end
      #   @meeting.update_attribute(:verified, true)
      # end
    end
  end


  def new
    @meeting = Meeting.new
    @creator = User.new
  end


  def create
    params[:meeting][:topics].reject!( &:blank? )
    @meeting = Meeting.new(params[:meeting])

    if @meeting.valid?
      
      @creator = User.find_or_new(params[:creator][:email], params[:creator][:name])

      if @creator.valid?
        @meeting.save
        @creator.save
        participation = @meeting.participations.new(:user_id => @creator.id, :is_attending => 1)
        participation.is_creator = true
        participation.is_admin = true
        participation.save

        if @creator.email.blank?
          redirect_to meeting_path(participation.link), notice: t("meeting.controller.create.notice.withoutauth")
        else
          UserMailer.authenticate(participation).deliver
          redirect_to root_path, notice: t("meeting.controller.create.notice.withauth")
        end
      else
        flash[:error] = t("meeting.controller.create.error.notcreated")
        render action: "new"
      end
    else
      flash[:error] = t("meeting.controller.create.error.notcreated")
      render action: "new"
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

      params[:meeting][:topics].reject!( &:blank? )
      # params[:participations].reject!( &:blank? )

      # @meeting.timezone = ActiveSupport::TimeZone.zones_map[params[:timezone]].to_s

      # @meeting.participations.each do |participation|
      #   unless params[:participations].include?(participation.user.email)
      #     participation.destroy
      #   end
      # end
      
      # if meeting.admin != -1
      #   admin = User.find(meeting.admin)
      #   admin.name = params[:admin][:name]
      #   admin.save
      #   name = " " + t("by") +" " + admin.name_formatted
      # else
      #   name = ""
      # end

      # params[:participations].each do |email|
      #   user = User.find_or_create_by_email(email)
      #   participation = meeting.participations.find_by_user_id(user.id)
      #   if participation.nil?
      #     meeting.participations.create(:user_id => user.id)
      #     UserMailer.invite(...).deliver    # see example in emails_controller
      #   end
      # end

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
      redirect_to root_path, notice: t("meeting.controller.destroy.notice")
    else
      flash[:error] = t("meeting.controller.destroy.error.notauthorized")
      redirect_to root_path
    end
  end


  def update_action_item
    participation = Participation.find_by_id(params[:id])

    participation.update_attributes(:action_item => params[:action_item], :deadline => params[:deadline])
        
    @static_minutes = participation.meeting.static_minutes

    # respond_to do |format|
    #  format.js
    # end
    render :js
  end


  def update_minutes
    participation = Participation.find_by_link(params[:id])

    if !participation.nil? && participation.is_creator
      participation.meeting.update_attribute(:minutes, params[:minutes])
    end

    render :nothing => true
  end


  def get_minutes
    participation = Participation.find_by_link(params[:id])

    unless participation.nil?
      @static_minutes = participation.meeting.static_minutes
      @minutes = meeting.minutes
      render :js
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
end