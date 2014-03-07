﻿class PubController < ApplicationController

	after_filter :set_access_control_headers

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

	def set_access_control_headers 
		headers["Access-Control-Allow-Origin"] = "http://hunnor:8082"
		headers["Access-Control-Request-Method"] = "*"
	end
	
	def log
	end

end
