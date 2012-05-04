class UserMailer < ActionMailer::Base

  def authenticate(participation)
    @name = participation.user.get_name
    @meeting = participation.link

    mail( :from => "coMeeting",           # not working...
          :to => "#{@name} <#{participation.user.email}>",
          :subject => t("email.views.authenticate.subject", :name => @name)
        )
  end

  def invite_email(sender, receiver, meeting)
    @sender_name = sender.get_name
    @receiver_name = receiver.get_name
  end
end