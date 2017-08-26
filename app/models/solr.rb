class Solr

	def initialize
		@solr = {}
		@solr[:hu] = RSolr.connect :url => ENV["SOLR_URL"] + "/hunnor.hu"
		@solr[:nb] = RSolr.connect :url => ENV["SOLR_URL"] + "/hunnor.nb"
	end

	def save lang, id, entry, document
		if id.to_s == entry.to_s
			data = document.to_xml(:encoding => "UTF-8", :indent_text => "\t", :indent => 1)
			@solr[lang].update :data => data
		else
			@solr[lang].delete_by_id id
		end
		@solr[lang].commit :commit_attributes => {}
	end

	def delete lang, id, entry
		if id.to_s == entry.to_s
			@solr[lang].delete_by_id id
			@solr[lang].commit :commit_attributes => {}
		end
	end

end
