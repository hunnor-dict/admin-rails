class PubController < ApplicationController

	def index
		redirect_to :controller => "auth", :action => "index"
	end

	def search
		dictionary = Dictionary.new
		@entries = dictionary.search params[:term], ""
		render :json => @entries, :callback => params[:callback]
	end

	def suggest
		dictionary = Dictionary.new
		@suggestions = dictionary.suggest params[:term]
		render :json => @suggestions, :callback => params[:callback]
	end

	def stat
		dictionary = Dictionary.new
		@stats = dictionary.stats
		render :json => @stats, :callback => params[:callback]
	end

	def log
	end

end

