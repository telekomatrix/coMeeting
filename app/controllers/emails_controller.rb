class EmailsController < ApplicationController
  def invite
    participation = Participation.find_by_link(params[:participation])

    if participation.nil?
      flash.now[:error] = t("email.controller.confirm.error.notfound")
    else
      sender = participation.user
      receiver = params[:user]
      meeting = participation.meeting

      UserMailer.invite_email(sender, receiver, meeting).deliver

      flash.now[:notice] = t("email.controller.confirm.notice")
    end
    render 'shared/flash_messages'
  end

  def authenticate
    participation = Participation.find_by_link(params[:participation])
    UserMailer.authenticate(participation).deliver
    flash.now[:notice] = "Sent!"
    render 'shared/flash_messages'
  end
end
