class AuthController < ApplicationController

	def logout
		if session[:hn_omniauth_provider] == nil
			redirect_to :action => "index"
		else
			@provider = session[:hn_omniauth_provider]
			case @provider
			when "facebook"
				@link = {:label => "Facebook", :href => "www.facebook.com"}
			when "google_oauth2"
				@link = {:label => "Google", :href => "www.google.com"}
			when "linkedin"
				@link = {:label => "LinkedIn", :href => "www.linkedin.com"}
			when "twitter"
				@link = {:label => "Twitter", :href => "www.twitter.com"}
			else
				@link = {:label => "", :href => ""}
			end
			reset_session
		end
	end

	def unauthorized
		@provider = session[:hn_omniauth_provider]
		@uid = session[:hn_omniauth_uid]
	end

	def callback
		auth_hash = request.env["omniauth.auth"]
		session[:hn_omniauth_uid] = auth_hash["uid"]
		session[:hn_omniauth_provider] = auth_hash["provider"]
		session[:hn_omniauth_name] = auth_hash["info"]["name"]
		editor = Editor.new auth_hash["provider"], auth_hash["uid"]
		if editor.authorized?
			session[:hn_id] = editor.id
			redirect_to :controller => "priv", :action => "index"
		else
			redirect_to :action => "unauthorized"
		end
	end

end

