HunNorService::Application.routes.draw do

	root :to => 'auth#index'

	get '/auth/:provider/callback', :to => 'auth#callback'
	get '/auth/failure', :to => 'auth#failure'
	get '/auth/logout', :to => 'auth#logout'
	get '/auth/unauthorized', :to => 'auth#unauthorized'

	get '/priv', :to => 'priv#index'
	get '/priv/list', :to => 'priv#list'
	get '/priv/edit', :to => 'priv#edit'
	post '/priv/save', :to => 'priv#save'
	post '/priv/delete', :to => 'priv#delete'

end
