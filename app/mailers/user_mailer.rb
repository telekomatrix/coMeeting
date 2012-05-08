class UserMailer < ActionMailer::Base
  default :from => "coMeeting <comeeting.occi@gmail.com>"

  def authenticate(participation)
    user = participation.user
    @name = user.name_formatted
    @link = participation.link

    mail( :to => user.email_address,
          :subject => t("email.views.authenticate.subject", :name => @name)
        )
  end

  def invite(sender_name, recipient)         # sender and recipient are both participations
    user = recipient.user
    @link = recipient.link
    @about = recipient.meeting.subject

    mail( :to => user.email_address,
          :subject => t("email.views.invite.subject", :name => sender_name)
        )
  end
end