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

	get '/pub', :to => 'pub#index'
	get '/pub/search', :to => 'pub#search'
	get '/pub/suggest', :to => 'pub#suggest'

	get '/stat/count', :to => 'pub#stat'
	get '/stat/hits', :to => 'pub#hits'
	get '/stat/searches', :to => 'pub#searches'
	get '/stat/missing', :to => 'pub#missing'

end
