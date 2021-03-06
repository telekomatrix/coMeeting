CoMeeting::Application.routes.draw do
	get 'reinvite' => 'emails#reinvite', :as => 'reinvite'

  post 'participations/:id/confirm' => 'participations#confirm', :as => 'confirm_participation'
	post 'participations/:id/decline' => 'participations#decline', :as => 'decline_participation'
  put  'participations/:id' => 'participations#update', :as => 'participation'
	get 'participations/get_admin_circles' => 'participations#get_admin_circles'

	post 'meetings/:id/update_minutes' => 'meetings#update_minutes'
	get 'meetings/:id/show_minutes' => 'meetings#show_minutes'
	get 'meetings/:id/download_pdf' => 'meetings#download_pdf', :as => 'download_pdf'

	scope "(:locale)", :locale => /en|pt/ do

		resources :meetings

		resources :users, :only => [:index, :destroy]
    
    ['about', 'faq', 'privacy', 'us'].each { |r|
      get "/#{r}", :controller => 'static', :action => r
    }
		
		root :to => 'static#home'

	end
	
	match '*uri' => redirect('/')
end