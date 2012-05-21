class ParticipationsController < ApplicationController
  def update
    puts 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'
    puts params
    render :nothing => true
  end

  def confirm
    @participation = Participation.find_by_link(params[:id])

    if @participation.nil?
      render :nothing => true
    else
      @participation.update_attribute(:is_attending, 1)

      flash.now[:notice] = t("participation.controller.confirm.notice")
      render 'change'
    end
  end
  
  
  def decline
    @participation = Participation.find_by_link(params[:id])
    
    if @participation.nil?
      render :nothing => true
    else
      @participation.update_attribute(:is_attending, -1)

      flash.now[:notice] = t("participation.controller.decline.notice")
      render 'change'
    end
  end
end