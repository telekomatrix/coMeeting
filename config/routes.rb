CoMeeting::Application.routes.draw do

	get "meetings/get_admin_circles"

	get "meetings/:id/download_pdf" => "meetings#download_pdf", :as => "download_pdf"
	get "meetings/get_minutes"
	post "meetings/update_minutes"
	post "meetings/update_action_item"
	
	get "authenticate" => "emails#authenticate", :as => "authenticate" # to be removed
	get "invite" => "emails#invite", :as => "invite"

	scope "(:locale)", :locale => /en|pt/ do
		
		get "meetings/:id/confirm" => "participations#confirm", :as => "confirm"
		get "meetings/:id/decline" => "participations#decline", :as => "decline"

		resources :meetings

		resources :users, :only => [:index, :destroy]
    
    ['about', 'privacy', 'us'].each { |r|
      get "/#{r}", :controller => 'static', :action => r
    }
		
		root :to => 'static#home'
	end
	
	# match '*uri' => redirect('/')
end
