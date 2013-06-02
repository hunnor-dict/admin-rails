HunNorService::Application.routes.draw do

	root :to => 'auth#index'

	match '/auth/:provider/callback', :to => 'auth#callback'
	match '/auth/failure', :to => 'auth#failure'
	match '/auth/logout', :to => 'auth#logout'
	match '/auth/unauthorized', :to => 'auth#unauthorized'

	match '/priv', :to => 'priv#index'
	match '/priv/list', :to => 'priv#list'
	match '/priv/edit', :to => 'priv#edit'
	match '/priv/save', :to => 'priv#save'
	match '/priv/delete', :to => 'priv#delete'

	match '/pub', :to => 'pub#index'
	match '/pub/suggest', :to => 'pub#suggest'

	match '/pub/log', :to => 'pub#log'

end
