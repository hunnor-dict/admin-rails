class PubController < ApplicationController

	def index
		redirect_to :controller => "auth", :action => "index"
	end

	def search
		dictionary = Dictionary.new
		@entries = dictionary.search params[:term], ""
		render :json => @entries
	end

	def suggest
		dictionary = Dictionary.new
		@suggestions = dictionary.suggest params[:term]
		render :json => @suggestions
	end

	def log
	end

end

