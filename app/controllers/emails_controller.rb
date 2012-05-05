class EmailsController < ApplicationController
  def reinvite
    sender = Participation.find_by_link(params[:link])
    if sender.nil?
      flash.now[:error] = t("email.controller.reinvite.error.notfound.sender")
    else

      recipient = sender.meeting.participations.where(:user_id => params[:id]).first
      if recipient.nil?
        flash.now[:error] = t("email.controller.reinvite.error.notfound.recipient")
      else

        UserMailer.invite(sender, recipient).deliver
        flash.now[:notice] = t("email.controller.reinvite.notice")

      end

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
