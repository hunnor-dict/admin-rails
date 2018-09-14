Rails.application.config.middleware.use OmniAuth::Builder do

	provider :facebook, ENV["OMNIAUTH_FACEBOOK_KEY"], ENV["OMNIAUTH_FACEBOOK_SECRET"], client_options: {
		callback_url: "https://hunnor-dict-admin.ovitas.no/auth/facebook/callback"
	}

	provider :google_oauth2, ENV["OMNIAUTH_GOOGLE_KEY"],ENV["OMNIAUTH_GOOGLE_SECRET"], {access_type: 'online', approval_prompt: ''}

	provider :linkedin, ENV["OMNIAUTH_LINKEDIN_KEY"], ENV["OMNIAUTH_LINKEDIN_SECRET"]

	provider :twitter, ENV["OMNIAUTH_TWITTER_KEY"], ENV["OMNIAUTH_TWITTER_SECRET"]
end
