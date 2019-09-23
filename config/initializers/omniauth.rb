Rails.application.config.middleware.use OmniAuth::Builder do

	provider :facebook, ENV["OMNIAUTH_FACEBOOK_KEY"], ENV["OMNIAUTH_FACEBOOK_SECRET"],
		callback_url: "https://dict-admin.hunnor.net/auth/facebook/callback"

	provider :linkedin, ENV["OMNIAUTH_LINKEDIN_KEY"], ENV["OMNIAUTH_LINKEDIN_SECRET"]

end
