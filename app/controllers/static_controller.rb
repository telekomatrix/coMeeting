class StaticController < ApplicationController
  def home
    @meeting = Meeting.new
    @creator = User.new
  end
  
	def about
	end

  def faq
  end
  
  def privacy
  end
  
  def us
  end
end