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

  def invite(sender, recipient)
    user = recipient.user
    @link = recipient.link
    @about = recipient.meeting.subject

    mail( :to => user.email_address,
          :subject => t("email.views.invite.subject", :name => sender.user.name_formatted)
        )
  end
end