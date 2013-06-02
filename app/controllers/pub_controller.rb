class PubController < ApplicationController

	def index
		redirect_to :controller => "auth", :action => "index"
	end

	def suggest
	end

	def log
	end

end

