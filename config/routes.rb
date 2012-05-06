CoMeeting::Application.routes.draw do

	# these first 4 routes probably need some refactoring
	get 'meetings/get_admin_circles'
	get 'meetings/get_minutes'
	post 'meetings/update_minutes'
	post 'meetings/update_action_item'
	
	get 'reinvite' => 'emails#reinvite', :as => 'reinvite'

  post 'participations/:id/confirm' => 'participations#confirm', :as => 'confirm_participation'
	post 'participations/:id/decline' => 'participations#decline', :as => 'decline_participation'

	get 'meetings/:id/download_pdf' => 'meetings#download_pdf', :as => 'download_pdf'

	scope "(:locale)", :locale => /en|pt/ do

		resources :meetings do
			resources :participations
		end

		resources :users, :only => [:index, :destroy]
    
    ['about', 'privacy', 'us'].each { |r|
      get "/#{r}", :controller => 'static', :action => r
    }
		
		root :to => 'static#home'

	end
	
	# match '*uri' => redirect('/')

end