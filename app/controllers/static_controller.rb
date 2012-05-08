class StaticController < ApplicationController
  def home
    @meeting = Meeting.new
    @creator = User.new
  end
  
	def management
	end
  
	def about
	end
  
  def privacy
  end
  
  def us
  end
end



