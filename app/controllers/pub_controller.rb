class PubController < ApplicationController

	after_filter :set_access_control_headers

	def search
		dictionary = Dictionary.new
		@entries = dictionary.search params[:term], params[:match]
		render :json => @entries, :callback => params[:callback]
	end

	def suggest
		dictionary = Dictionary.new
		@suggestions = dictionary.suggest params[:term]
		render :json => @suggestions, :callback => params[:callback]
	end

	def set_access_control_headers 
		headers["Access-Control-Allow-Origin"] = "http://hunnor-dict.ovitas.no"
		headers["Access-Control-Request-Method"] = "*"
	end

end
