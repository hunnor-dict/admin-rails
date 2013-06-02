require File.expand_path('../boot', __FILE__)
require "action_controller/railtie"
require "action_mailer/railtie"
require "active_resource/railtie"
require "sprockets/railtie"
require "rails/test_unit/railtie"
if defined?(Bundler)
	Bundler.require(*Rails.groups(:assets => %w(development test)))
end
module HunNorService
	class Application < Rails::Application
		config.encoding = "utf-8"
		config.assets.enabled = true
	end
end
