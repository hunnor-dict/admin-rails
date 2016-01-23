class Solr

	def initialize
		@solr = {}
		@solr[:hu] = RSolr.connect :url => ENV["SOLR_URL"] + "/hunnor-hu"
		@solr[:nb] = RSolr.connect :url => ENV["SOLR_URL"] + "/hunnor-nb"
		solr_dir = ENV["SOLR_DIR"]
		@xsl = {}
		@xsl[:nb]  = Nokogiri::XSLT(File.open("#{solr_dir}/hunnor-nb/conf/import.xsl", "rb"))
		@xsl[:hu]  = Nokogiri::XSLT(File.open("#{solr_dir}/hunnor-hu/conf/import.xsl", "rb"))
	end

	def save lang, id, entry, document
		if id.to_s == entry.to_s
			solr_doc = @xsl[lang].transform document
			data = solr_doc.to_xml(:encoding => "UTF-8", :indent_text => "\t", :indent => 1)
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
