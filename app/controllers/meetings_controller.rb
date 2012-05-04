class MeetingsController < ApplicationController
  before_filter :authenticate, :only => [:index]

  def index
    @meetings = Meeting.order('created_at ASC').paginate(:page => params[:page], :per_page => 20)
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
    # params[:meeting][:topics].reject!( &:blank? )

    meeting = Meeting.new(params[:meeting])

    if meeting.valid?
      
      # params[:users].each do |email|
      #  user = User.find_or_create_by_email(email)
      #  @meeting.participations.create(:user_id => user.id)
      # end
      creator = User.find_or_new(params[:creator][:email], params[:creator][:name])

      if creator.valid?
        meeting.save
        creator.save
        participation = meeting.participations.new(:user_id => creator.id, :is_attending => 1)
        participation.is_creator = true
        participation.is_admin = true
        participation.save

        # meeting.participations.each do |participation|
        #   UserMailer.email(participation.user.email, t("email.participant.subject", :admin => params[:creator][:name].empty? ? "" : " by "+ params[:creator][:name] ), t("email.participant.body", :link => "#{ENV['HOST']}/#{params[:locale]}/meetings/#{participation.link}")).deliver
        # end

        if creator.email.blank?
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
    # params[:meeting][:topics].reject!( &:blank? )
    # params[:participations].reject!( &:blank? )

    participation = Participation.find_by_link(params[:id])
    if participation.nil?
      flash[:error] = t("meeting.controller.update.error.notfound")
      redirect_to root_path
    elsif !participation.is_admin
      flash[:error] = t("meeting.controller.update.error.notauthorized")
      redirect_to root_path
    else
      meeting = partipation.meeting

      # meeting.timezone = ActiveSupport::TimeZone.zones_map[params[:timezone]].to_s

      # meeting.participations.each do |participation|
      #   unless params[:participations].include?(participation.user.email)
      #     participation.destroy
      #   end
      # end
      
      # if meeting.admin != -1
      #   admin = User.find(meeting.admin)
      #   admin.name = params[:admin][:name]
      #   admin.save
      #   name = " " + t("by") +" " + admin.get_name
      # else
      #   name = ""
      # end

      params[:participations].each do |email|
        user = User.find_or_create_by_email(email)
        participation = meeting.participations.find_by_user_id(user.id)
        if participation.nil?
          meeting.participations.create(:user_id => user.id)
          # UserMailer.email(email, t("email.participant.subject", :admin => name), t("email.participant.body", :link => "#{ENV['HOST']}/#{params[:locale]}/meetings/#{participation.link}")).deliver
        end
      end

      if meeting.update_attributes(params[:meeting])
        redirect_to meeting_path(@meeting.link), notice: t("meeting.controller.update.notice")
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

    meeting = Meeting.find_by_id(participation.meeting_id)
        
    @static_minutes = create_static_minutes(meeting)

    respond_to do |format|
      format.js
    end
    # render :js ?
  end


  def update_minutes
    meeting = Meeting.find_by_link(params[:id])

    meeting.update_attribute(:minutes, params[:minutes])

    render :nothing => true
  end


  def get_minutes
    meeting = Meeting.find_by_link(params[:id])
    
    @static_minutes = create_static_minutes(meeting)
    
    @minutes = meeting.minutes
    
    render :js
    # respond_to do |format|
    # format.js
    # end
  end

  respond_to :js
  def get_admin_circles
    user = User.find_by_email(params[:email])

    @data = ""
    user.circles.each do |u|
      email = User.find_by_id(u).email
      if email.include?(params[:term])
        @data = @data + email.to_s
        @data = @data + ", "
      end
    end

    respond_with(@data)
  end


  def download_pdf
    participation = Participation.find_by_link(params[:id])

    unless participation.nil?
      meeting = participation.meeting
      static_minutes = create_static_minutes(meeting)

      my_file = "tmp/minutes_#{SecureRandom.urlsafe_base64(10)}.pdf"

      Prawn::Document.generate(my_file) do
        text static_minutes + (meeting.minutes.nil? ? "" : "\n\n" + meeting.minutes)
      end

      send_file my_file
    end
  end 
  

  protected
  def create_static_minutes(meeting)

    topics = ""
    participants = ""
    action_items = ""

    meeting.topics.each do |topic|
      topics += "- " + topic + "\n\t"
    end

    meeting.participations.each do |participation|
      if participation.user.name.blank?
        participants += "- #{participation.user.email}".ljust(60)
      else
        participants += "- #{participation.user.name} (#{participation.user.email})".ljust(60)
      end
      
      if participation.is_attending == 1
        participants += " " + t("meeting.views.show.text.attending.attended")
      elsif participation.is_attending == 0
        participants += " " + t("meeting.views.show.text.attending.unanswered")
      elsif participation.is_attending == -1
        participants += " " + t("meeting.views.show.text.attending.not_attended")
      end
      participants += "\n\t"
      # if !participation.action_item.nil? && !participation.deadline.nil? && !participation.action_item.empty? && !participation.deadline.empty?
      #   if !participation.user.name.empty?
      #     action_items += "\n\t- " + participation.user.name + " (" + participation.user.email + ")" + " => " + participation.action_item.to_s + " " + t('until') + " " + participation.deadline.to_s
      #   else
      #     action_items += "\n\t- " + participation.user.email + " => " + participation.action_item.to_s + " " + t('until') + " " + participation.deadline.to_s
      #   end
      # end
    end
    
    minutes = "\ncoMeeting\n" +
      "\n" + meeting.subject + "\n" +
      "\n #{t('pdf.created_by')}: #{meeting.creator.get_name_and_email}\n" +
      "\n #{t('pdf.location')}: #{meeting.location}" +
      "\n #{t('pdf.date')}: #{meeting.date.strftime("%d/%m/%Y")}" +
      "\n #{t('pdf.time')}: #{meeting.time.strftime("%1Hh:%Mm")} #{meeting.time_zone}" +
      "\n #{t('pdf.duration')}: #{meeting.duration.strftime("%1Hh:%Mm")}" +
      "\n #{t('pdf.extra_info')}: #{meeting.extra_info}"
    

    
    minutes +=
      "\n\n\t" + t("pdf.topics") + ":" +
      "\n\t" + topics +
      "\n\t" + t("pdf.participants") + ":" +
      "\n\t" + participants # +
    #   "\n\t" + t("actions") + ":" + action_items
      
    return minutes
  end 
end