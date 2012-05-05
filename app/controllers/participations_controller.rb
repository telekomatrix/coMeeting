class ParticipationsController < ApplicationController
  def confirm
    participation = Participation.find_by_link(params[:id])
    
    meeting = Meeting.find_by_id(participation.meeting_id)
    participations = meeting.participations
    
    if meeting.admin != -1
      admin = User.find(meeting.admin)
      if !admin.nil?
        participations.each do |participant|
          if participant.is_attending == 1
            if !participant.user.circles.include?(participation.user.id)
              participant.user.circles << participation.user.id
              participation.user.circles << participant.user.id
            end
          end
          participant.user.save
        end
        if !admin.circles.include?(participation.user.id)
          admin.circles << participation.user.id
          participation.user.circles << admin.id
          participation.user.save
          admin.save
        end
      end
    end
    
    participation.update_attribute(:is_attending, 1)

    redirect_to meeting_path(participation.link), notice: t("attending.notice.confirm") }
  end
  
  
  def decline
    participation = Participation.find_by_link(params[:id])
    
    participation.update_attribute(:is_attending, -1)

    redirect_to meeting_path(participation.link), notice: t("attending.notice.decline") }
  end
end