class Meeting < ActiveRecord::Base
  serialize :topics, Array

  #validates :subject, :presence => true
  #validates :date, :presence => true
  #validates :time, :presence => true
  #validates :time_zone, :presence => true

  has_many :participations, :dependent => :destroy
  has_many :users, :through => :participations

  validates_associated :participations


  def creator
    self.participations.where(:is_creator => true).first.user
  end


  def find_participation_by_email(email)
    self.participations.each do |participation|
      return participation if participation.user.email == email
    end
    nil
  end


  def static_minutes

    topics = ""
    participants = ""
    action_items = ""

    self.topics.each do |topic|
      topics += "- " + topic + "\n\t"
    end

    self.participations.each do |participation|
      participants += "- #{participation.user.name_and_email}".ljust(45)
      
      if participation.is_attending == 0
        participants += " " + I18n.t("pdf.attending.unanswered")
      elsif participation.is_attending == 1
        participants += " " + I18n.t("pdf.attending.confirmed")
      elsif participation.is_attending == -1
        participants += " " + I18n.t("pdf.attending.declined")
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
      "\n" + subject + "\n" +
      "\n #{I18n.t('pdf.created_by')}: #{creator.name_and_email}\n" +
      "\n #{I18n.t('pdf.location')}: #{location}"
    if !date.nil?
      minutes += "\n #{I18n.t('pdf.date')}: #{date.strftime("%d/%m/%Y")}"
    end
    if !time.nil?
      minutes += "\n #{I18n.t('pdf.time')}: #{time.strftime("%1Hh:%Mm")} #{time_zone}"
    end
    if !duration.nil?
      minutes += "\n #{I18n.t('pdf.duration')}: #{duration.strftime("%1Hh:%Mm")}"
    end
    minutes += "\n #{I18n.t('pdf.extra_info')}: #{extra_info}"
    

    
    minutes +=
      "\n\n\t" + I18n.t("pdf.topics") + ":" +
      "\n\t" + topics +
      "\n\t" + I18n.t("pdf.participants") + ":" +
      "\n\t" + participants # +
    #   "\n\t" + t("actions") + ":" + action_items
      
    minutes
  end 


  def minutes_to_pdf
    static_minutes = self.static_minutes
    minutes = self.minutes unless self.minutes.nil?
    static_minutes + "\n\n" + minutes
  end
end