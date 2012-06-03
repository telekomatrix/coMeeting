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

  respond_to :js
  def get_admin_circles
    participation = Participation.find_by_link(params[:participation_id])
    @data = ""
    if !participation.nil?
      user = participation.user
      user.circles.each do |u|
        email = u.email
        if email.include?(params[:term])
          @data = @data + email.to_s + ','
        end
      end
    end

    respond_with(@data)
  end
end