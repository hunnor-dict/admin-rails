#encoding: utf-8
class PrivController < ApplicationController

	layout false, :except => :index

	def unauthorized?
		session[:hn_id] == nil
	end

	def index
		if unauthorized?
			redirect_to :controller => "auth", :action => "index"
		else
			@name = session[:hn_omniauth_name]
			@uid = session[:hn_omniauth_uid]
			@provider = session[:hn_omniauth_provider]
		end
	end

	def list
		if unauthorized?
			render :nothing => true
			return
		end
		case params[:lang]
		when "hu"
			@lang = "hu"
		when "nb"
			@lang = "nb"
		else
			render :nothing => true
			return
		end
		dictionary = Dictionary.new
		dictionary.set_lang [@lang]
		case params[:letter]
		when String
			if !params[:letter].empty?
				dictionary.set_letter params[:letter]
			end
		end
		case params[:term]
		when String
			if !params[:term].empty?
				dictionary.set_term params[:term]
			end
		end
		case params[:stat]
		when "1"
			dictionary.set_stat params[:stat]
		end
		@entries = dictionary.lookup
	end

	def edit
		if unauthorized?
			render :nothing => true
			return
		end
		case params[:lang]
		when "hu"
			lang = :hu
		when "nb"
			lang = :nb
		else
			render :nothing => true
			return
		end
		case params[:id]
		when String
			if params[:id].empty?
				render :nothing => true
				return
			else
				@id = params[:id]
				@entry = Entry.new lang, @id, {:trans => true}, {:term => params[:term]}
			end
		else
			render :nothing => true
			return
		end
	end

	def save
		if unauthorized?
			render :nothing => true
			return
		end
		case params[:entrylang]
		when "hu"
			lang = :hu
		when "nb"
			lang = :nb
		else
			render :nothing => true
			return
		end
		id = "N"
		if params[:id] != "N"
			id = params[:id].to_i
			if id < 1
				render :nothing => true
				return
			end
		end
		entry = Entry.new lang, id, {:trans => true}, nil
		values = {:entry => params[:entry], :forms => params[:forms], :pos => params[:pos], :status => params[:status], :trans => params[:trans]}
		results = entry.update values, session[:hn_id]
		if params[:id] == "N"
			@addition = entry.id
		end
		@errors = results[:errors]
		@sql = results[:sql]
		@clock = Time.new
		if @errors.empty?
			solr_entry = Entry.new lang, entry.id, {:trans => true}, nil
			if solr_entry.id == solr_entry.entry
				solr_doc = solr_entry.to_xml_doc
				solr_add_string = solr_entry.to_solr_add_string solr_doc
				if lang = :hu
					solr_url = "http://localhost:8080/solr/hunnor-hu/update"
					response = http.post(solr_url, solr_add_string)
				elsif lang = :nb
					solr_url = "http://localhost:8080/solr/hunnor-nb/update"
					response = http.post(solr_url, solr_add_string)
				end
			end
		end
	end

	def delete
		if unauthorized?
			render :nothing => true
			return
		end
		entry = Entry.new params[:entrylang].to_sym, params[:id], nil, nil
		@deleted = false
		@error = ""
		@sql = []
		if entry.exists?
			refs = entry.referrers
			if refs.empty?
				@sql = entry.delete
				@deleted = true
				if params[:entrylang].to_sym = :hu
					solr_url = "http://localhost:8080/solr/hunnor-hu/update"
					response = http.post(solr_url, "<delete><id>#{params[:id]}</id></delete>")
				elsif params[:entrylang].to_sym = :nb
					solr_url = "http://localhost:8080/solr/hunnor-nb/update"
					response = http.post(solr_url, "<delete><id>#{params[:id]}</id></delete>")
				end
			else
				@error = "A megadott szócikk nem tötölhető, mert a következő szócikkek hivatkoznak rá: " + refs.join(", ")
			end
		else
			@error = "A megadott szócikk (#{params[:entrylang]}, #{params[:id]}) nem létezik."
		end
		@clock = Time.new
	end

end

