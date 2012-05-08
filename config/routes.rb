CoMeeting::Application.routes.draw do

	# post 'meetings/:id/update_action_item'
	
	get 'reinvite' => 'emails#reinvite', :as => 'reinvite'

  post 'participations/:id/confirm' => 'participations#confirm', :as => 'confirm_participation'
	post 'participations/:id/decline' => 'participations#decline', :as => 'decline_participation'

	post 'meetings/:id/update_minutes' => 'meetings#update_minutes'
	get 'meetings/:id/show_minutes' => 'meetings#show_minutes'
	get 'meetings/:id/download_pdf' => 'meetings#download_pdf', :as => 'download_pdf'

	scope "(:locale)", :locale => /en|pt/ do

		resources :meetings

		resources :users, :only => [:index, :destroy]
    
    ['about', 'privacy', 'us'].each { |r|
      get "/#{r}", :controller => 'static', :action => r
    }
		
		root :to => 'static#home'

	end
	
	match '*uri' => redirect('/')

end