class ParticipationsController < ApplicationController
  def confirm
    participation = Participation.find_by_link(params[:id])

    if participation.nil?
      render :nothing => true
    else
      participation.update_attribute(:is_attending, 1)

      flash.now[:notice] = t("participation.controller.confirm.notice")
      render 'shared/flash_messages'
    end
  end
  
  
  def decline
    participation = Participation.find_by_link(params[:id])
    
    if participation.nil?
      render :nothing => true
    else
      participation.update_attribute(:is_attending, -1)

      flash.now[:notice] = t("participation.controller.decline.notice")
      render 'shared/flash_messages'
    end
  end
end