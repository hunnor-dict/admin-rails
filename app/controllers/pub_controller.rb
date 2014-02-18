class PubController < ApplicationController

	def index
		redirect_to :controller => "auth", :action => "index"
	end

	def search
		dictionary = Dictionary.new
		@entries = dictionary.search params[:term], ""
	end

	def suggest
	end

	def log
	end

end

