#encoding: utf-8
class Entry

	attr_accessor :lang, :id, :entry, :form, :forms, :pos, :status, :trans

	def initialize
		
	end

	def initialize lang, id, fields, extras
		@lang = lang
		if id.nil?
			return
		end
		@id = id.to_s
		if @id.empty?
			return
		end
		if @id == "N"
			case extras
			when Hash
				if extras[:term].nil?
					@forms = {"0" => {1 => "szótári_alak"}}
				else
					if extras[:term].empty?
						@forms = {"0" => {1 => "szótári_alak"}}
					else
						@forms = {"0" => {1 => "#{extras[:term]}"}}
					end
				end
			else
				@forms = {"0" => {1 => "szótári_alak"}}
			end
			@trans = "<senseGrp>\n  <sense>\n    <trans></trans>\n  </sense>\n</senseGrp>\n"
			@exists = true
		else
			database = Database.new
			db = database.db
			tables = database.tables @lang
			if tables.nil?
				return
			end
			columns = database.columns
			eXistenZ_res = db.query "SELECT #{columns[:forms][:id]} FROM #{tables[:forms]} WHERE #{columns[:forms][:id]} = '#{@id}'"
			if eXistenZ_res.count == 0
				@exists = false
				database.close
				return
			else
				@exists = true
			end
			@forms = {}
			res = db.query "SELECT * FROM #{tables[:forms]} WHERE #{columns[:forms][:id]} = '#{@id}' ORDER BY #{columns[:forms][:par]}, #{columns[:forms][:seq]}"
			res.each do |row|
				if @form.nil?
					@form = row[columns[:forms][:orth]]
				end
				@entry = row[columns[:forms][:entry]]
				if @pos.nil?
					@pos = row[columns[:forms][:pos]]
				end
				@status = row[columns[:forms][:status]]
				if @forms[row[columns[:forms][:par]]].nil?
					@forms[row[columns[:forms][:par]]] = {}
				end
				@forms[row[columns[:forms][:par]]][row[columns[:forms][:seq]]] = row[columns[:forms][:orth]]
			end
			case fields
			when Hash
				case fields[:trans]
				when true
					@trans = "<senseGrp>\n  <sense>\n    <trans></trans>\n  </sense>\n</senseGrp>\n"
					res = db.query "SELECT #{columns[:trans][:trans]} FROM #{tables[:trans]} WHERE #{columns[:trans][:id]} = '#{@id}'"
					res.each do |row|
						@trans = row[columns[:trans][:trans]]
					end
				end
			end
			database.close
		end
	end

	def exists?
		return @exists
	end

	def accepts_entry? entry
		database = Database.new
		db = database.db
		tables = database.tables @lang
		columns = database.columns
		entry_res = db.query("SELECT #{columns[:forms][:entry]} FROM #{tables[:forms]} WHERE #{columns[:forms][:entry]} = '#{entry}'")
		if entry_res.count == 0
			exists = false
		else
			exists = true
		end
		database.close
		return exists
	end

	def accepts_pos? pos
		case @lang
		when :hu
			["ige", "fn", "hsz", "nével", "röv", "névm", "mn", "ksz", "módsz", "névut", "isz", "szn", "igek"].include? pos
		when :nb
			["subst", "verb", "adj", "adv", "prep", "pron", "tall", "konj", "interj", "fork", "inf", "art"].include? pos
		else
			false
		end
	end

	def accepts_status? status
		["0", "1", "2"].include? status.to_s
	end

	def validate_trans trans
		xml_errors = []
		if trans.nil?
			xml_errors.push "Translation is NIL."
			return xml_errors
		end
		trans_string = "<hnDict updated=\"1970-01-01\" xmlns=\"http://dict.hunnor.net\"><entryGrp head=\"A\"><entry id=\"1\"><formGrp><form><orth n=\"1\">A</orth></form></formGrp>" + trans + "</entry></entryGrp></hnDict>"
		trans_xml = Nokogiri::XML trans_string
		xml_errors += trans_xml.errors
		sense_schema = nil
		if @lang == :hu
			sense_schema = Nokogiri::XML::Schema(File.open(Rails.root.join("public", "hunnor.net.Schema.HN.xsd"), "rb"))
		elsif @lang == :nb
			sense_schema = Nokogiri::XML::Schema(File.open(Rails.root.join("public", "hunnor.net.Schema.NH.xsd"), "rb"))
		end
		xml_errors += sense_schema.validate trans_xml
		return xml_errors
	end

	def update values, editor
		database = Database.new
		db = database.db
		tables = database.tables @lang
		if tables.nil?
			return
		end
		columns = database.columns
		errors = []
		sql = []

		if !exists?
			errors.push "A(z) '#{@lang}' nyelvben nincs '#{@id}' azonosítójú szócikk."
			ret_value = {:errors => errors, :sql => sql}
			database.close
			return ret_value
		end
		
		if !accepts_pos? values[:pos]
			errors.push "A(z) '#{@lang}' nyelvben nincs '#{values[:pos]}' szófaj."
			ret_value = {:errors => errors, :sql => sql}
			database.close
			return ret_value
		end
		
		if values[:entry] != ""
			if !accepts_entry? values[:entry]
				errors.push "A(z) '#{@lang}' nyelvben nem hivatkozhatsz '#{values[:entry]}' azonosítójú szócikkre."
				ret_value = {:errors => errors, :sql => sql}
				database.close
				return ret_value
			end
		end
		
		if !accepts_status? values[:status]
			errors.push "Érvénytelen státusz: '#{values[:status]}'."
			ret_value = {:errors => errors, :sql => sql}
			database.close
			return ret_value
		end

		# validate forms
		forms_new = YAML::load(values[:forms])

		if @id == "N"
			action = "insert"
			id_res = db.query("SELECT MAX(id) AS max_id FROM #{tables[:forms]}")
			id_row = id_res.first
			@id = id_row['max_id'] + 1
			if values[:entry] == ""
				@entry = @id
			else
				@entry = values[:entry]
			end
			@forms = {}
			forms_new.each do |par_key, par_val|
				if @forms[par_key].nil?
					@forms[par_key] = {}
				end
				par_val.each do |seq_key, seq_val|
					@forms[par_key][seq_key] = seq_val
					if @form.nil?
						@form = seq_key
					end
					sql.push "INSERT INTO #{tables[:forms]} (#{columns[:forms][:id]}, #{columns[:forms][:entry]}, #{columns[:forms][:orth]}, #{columns[:forms][:pos]}, #{columns[:forms][:par]}, #{columns[:forms][:seq]}, #{columns[:forms][:status]}) VALUES('#{@id}', '#{@entry}', '#{db.escape(seq_val)}', '#{db.escape(values[:pos])}', '#{db.escape(par_key)}', '#{seq_key}', '#{values[:status]}')"
				end
			end
			@pos = values[:pos]
			@status = values[:status]
		else
			action = "update"
			form_global_changes = []
			if @entry != values[:entry].to_i
				form_global_changes.push "#{columns[:forms][:entry]} = '#{values[:entry]}'"
				@entry = values[:entry]
			end
			if @pos != values[:pos]
				form_global_changes.push "#{columns[:forms][:pos]} = '#{db.escape(values[:pos])}'"
				@pos = values[:pos]
			end
			if @status != values[:status].to_i
				form_global_changes.push "#{columns[:forms][:status]} = '#{values[:status]}'"
				@status = values[:status]
			end
			if !form_global_changes.empty?
				changes = form_global_changes.join(", ")
				sql.push "UPDATE #{tables[:forms]} SET #{changes} WHERE #{columns[:forms][:id]} = '#{@id}'"
			end
			forms_old = @forms
			forms_old_a = []
			forms_old.each do |par_key, par_val|
				par_val.each do |seq_key, seq_val|
					forms_old_a.push "#{par_key};#{seq_key};#{seq_val}"
				end
			end
			forms_new_a = []
			forms_new.each do |par_key, par_val|
				par_val.each do |seq_key, seq_val|
					forms_new_a.push "#{par_key};#{seq_key};#{seq_val}"
				end
			end
			removed_forms = forms_old_a - forms_new_a
			added_forms = forms_new_a - forms_old_a
			removed_forms.each do |removed_form|
				rm_a = removed_form.split ";"
				sql.push "DELETE FROM #{tables[:forms]} WHERE #{columns[:forms][:id]} = '#{@id}' AND #{columns[:forms][:par]} = '#{db.escape(rm_a[0])}' AND #{columns[:forms][:seq]} = '#{rm_a[1]}' AND #{columns[:forms][:orth]} = '#{db.escape(rm_a[2])}'"
			end
			added_forms.each do |added_form|
				add_a = added_form.split ";"
				sql.push "INSERT INTO #{tables[:forms]} (#{columns[:forms][:id]}, #{columns[:forms][:entry]}, #{columns[:forms][:orth]}, #{columns[:forms][:pos]}, #{columns[:forms][:par]}, #{columns[:forms][:seq]}, #{columns[:forms][:status]}) VALUES ('#{@id}', '#{@entry}', '#{db.escape(add_a[2])}', '#{db.escape(values[:pos])}', '#{db.escape(add_a[0])}', '#{add_a[1]}', '#{values[:status]}')"
			end
		end

		# validate and update translation
		trans_errors = validate_trans values[:trans]
		if trans_errors.empty?
			if values[:trans] != @trans
				if action == "update"
					trans_check_res = db.query "SELECT id FROM #{tables[:trans]} WHERE id = '#{@id}'"
					if trans_check_res.size == 0
						sql.push "INSERT INTO #{tables[:trans]} (#{columns[:trans][:id]}, #{columns[:trans][:trans]}) VALUES ('#{@id}', '#{db.escape(values[:trans])}')"
					else
						sql.push "UPDATE #{tables[:trans]} SET #{columns[:trans][:trans]} = '#{db.escape(values[:trans])}' WHERE #{columns[:trans][:id]} = '#{id}'"
					end
				else
					sql.push "INSERT INTO #{tables[:trans]} (#{columns[:trans][:id]}, #{columns[:trans][:trans]}) VALUES ('#{@id}', '#{db.escape(values[:trans])}')"
				end
			end
			@trans = values[:trans]
		else
			errors += trans_errors
		end

		if errors.empty?
			clock = Time.new
			timestamp = clock.strftime("%Y%m%d%H%M%S")
			sql.push "INSERT INTO hn_log_edit (editor_id, lang, entry_id, action, timestamp) VALUES ('#{editor}', '#{@lang}', '#{id}', '#{action}', '#{timestamp}')"
			sql.each do |sql_query|
				db.query sql_query
			end
		end

		@forms = forms_new
		par_keys = @forms.keys.sort!
		par_key = par_keys.first
		seq_map = @forms.fetch(par_key)
		seq_keys = seq_map.keys.sort!
		seq_key = seq_keys.first
		@form = seq_map.fetch(seq_key)

		solr = Solr.new
		solr.save @lang, @id, @entry, to_xml_doc

		ret_value = {:errors => errors, :sql => sql}
		database.close
		return ret_value

	end

	def delete
		database = Database.new
		db = database.db
		tables = database.tables @lang
		columns = database.columns
		sql = []
		sql.push "DELETE FROM #{tables[:forms]} WHERE #{columns[:forms][:id]} = '#{db.escape(@id)}'"
		sql.push "DELETE FROM #{tables[:trans]} WHERE #{columns[:forms][:id]} = '#{db.escape(@id)}'"
		sql.each do |sql_query|
			db.query sql_query
		end
		database.close

		solr = Solr.new
		solr.delete @lang, @id, @entry

		return sql
	end

	def referrers
		database = Database.new
		db = database.db
		tables = database.tables @lang
		columns = database.columns
		refs = []
		form_check_res = db.query "SELECT DISTINCT #{columns[:forms][:id]}, #{columns[:forms][:entry]}, #{columns[:forms][:orth]} FROM #{tables[:forms]} WHERE #{columns[:forms][:entry]} = '#{@id}' AND #{columns[:forms][:id]} <> '#{@id}' AND #{columns[:forms][:seq]} = 1"
		if form_check_res.size != 0
			form_check_res.each do |form_check_row|
				refs.push  "#{form_check_row["orth"]} (#{form_check_row["id"]})"
			end
		end
		database.close
		return refs
	end

	def bob_link
		bob_link :fallback
	end

	def bob_link mode
		return "http://ordbok.uib.no/perl/ordbok.cgi?OPP=#{@form}&ant_bokmaal=5&ant_nynorsk=5&bokmaal=+&ordbok=bokmaal"
	end

	def to_xml_doc
		additional_forms = []
		additional_ids = get_ids_from_entry
		additional_ids.each do |additional_id|
			additional_form = load_forms_for_id additional_id
			additional_forms.push additional_form
		end
		builder = Nokogiri::XML::Builder.new do |document|
			document.hnDict(:xmlns => "http://dict.hunnor.net") do |hn_dict|
			hn_dict.entryGrp do |entry_grp|
			entry_grp.entry(:id => @id) do |entry|
				entry.formGrp do |formGrp|
					formGrp.form(:primary => "yes") do |form|
						form.orth do |orth|
							# orth/@n only used in PDF
							orth.text @form
						end
						form.pos do |pos|
							pos.text @pos
						end
						infl_codes_str = @forms.keys.join ":"
						if @pos == "adj" || @pos == "subst" || @pos == "verb"
							h = get_infl_codes infl_codes_str
							if !h["bob"].nil?
								form.inflCode(:type => "bob") do |infl_code|
									infl_code.text h["bob"]
								end
							end
							if !h["suff"].nil?
								form.inflCode(:type => "suff") do |infl_code|
									infl_code.text h["suff"]
								end
							end
							forms_a_a = get_forms_a_a @forms
							forms_a_a.each_with_index do |forms_a_val, forms_a_key|
								if !forms_a_val.empty?
								form.inflPar do |infl_par|
									forms_a_val.each_with_index do |ff_val, ff_key|
										infl_par.inflSeq(:form => "#{forms_a_key}-#{ff_key}") do |infl_seq|
											infl_seq.text ff_val
										end
									end
								end
								end
							end
						end
					end

					additional_forms.each do |additional_form|
						formGrp.form(:primary => "no") do |form|
							first_par_key = additional_form.keys[0]
							seqs = additional_form[first_par_key]
							first_seq_key = seqs.keys[0]
							form_orth = seqs[first_seq_key]
							form.orth do |orth|
								# orth/@n only used in PDF
								orth.text form_orth
							end
							infl_codes_str = additional_form.keys.join ":"
							if @pos == "adj" || @pos == "subst" || @pos == "verb"
								h = get_infl_codes infl_codes_str
								if !h["bob"].nil?
									form.inflCode(:type => "bob") do |infl_code|
										infl_code.text h["bob"]
									end
								end
								if !h["suff"].nil?
									form.inflCode(:type => "suff") do |infl_code|
										infl_code.text h["suff"]
									end
								end
								forms_a_a = get_forms_a_a additional_form
								forms_a_a.each_with_index do |forms_a_val, forms_a_key|
									if !forms_a_val.empty?
									form.inflPar do |infl_par|
										forms_a_val.each_with_index do |ff_val, ff_key|
											infl_par.inflSeq(:form => "#{forms_a_key}-#{ff_key}") do |infl_seq|
												infl_seq.text ff_val
											end
										end
									end
									end
								end
							end
						end
					end

				end
			end
			end
			end
		end
		document = builder.doc
		root = document.root
		entry = root.at "entryGrp/entry"
		trans_without_spaces = remove_spaces @trans
		trans_dom = Nokogiri::XML "<foo>" + trans_without_spaces + "</foo>"
		trans_root = trans_dom.root
		trans_root.xpath("senseGrp").each do |sense_grp|
			entry.add_child sense_grp
		end
		return document
	end

	def load_forms_for_id id
		database = Database.new
		db = database.db
		tables = database.tables @lang
		columns = database.columns
		forms = {}
		res = db.query "SELECT * FROM #{tables[:forms]} WHERE #{columns[:forms][:id]} = '#{id}' ORDER BY #{columns[:forms][:par]}, #{columns[:forms][:seq]}"
		res.each do |row|
			if forms[row[columns[:forms][:par]]].nil?
				forms[row[columns[:forms][:par]]] = {}
			end
			forms[row[columns[:forms][:par]]][row[columns[:forms][:seq]]] = row[columns[:forms][:orth]]
		end
		database.close
		return forms
	end

	def get_ids_from_entry
		database = Database.new
		db = database.db
		tables = database.tables @lang
		columns = database.columns
		ids = []
		res = db.query "SELECT DISTINCT #{columns[:forms][:id]} FROM #{tables[:forms]} WHERE #{columns[:forms][:entry]} = '#{@entry}' ORDER BY #{columns[:forms][:orth]}"
		res.each do |row|
			r_id = row[columns[:forms][:id]]
			if r_id != @entry
				ids.push r_id
			end
		end
		database.close
		return ids
	end

	def get_forms_a_a forms
		keys = []
		case @pos
		when "adj"
			keys.push 5
			keys.push 6
		when "subst"
			keys.push 2
			keys.push 3
			keys.push 4
		when "verb"
			keys.push 4
			keys.push 6
			keys.push 7
		end
		forms_a = []
		forms.each do |form_key, form_val|
			par_a = []
			keys.each do |key|
				if !form_val[key].nil? && form_val[key] != ""
					par_a.push form_val[key]
				end
			end
			if !forms_a.include? par_a
				forms_a.push par_a
			end
		end
		return forms_a
	end

	def get_infl_codes str
		h = {}
		case str
		when "700:900", "702:902"
			h['bob'] = "f1:m1"
			h['suff'] = "-en/-a"
		when "700:800:810:900", "702:800:810:902"
			h['bob'] = "f1:m1:n1"
			h['suff'] = "-en/-a/-et"
		when "700:801:811:900", "702:802:812:902"
			h['bob'] = "f1:m1:n2"
			h['suff'] = "-en/-a/-et"
		when "700:800:801:810:811:900"
			h['bob'] = "f1:m1:n3"
			h['suff'] = "-en/-a/-et"
		when "700", "700:703", "702"
			h['bob'] = "m1"
			h['suff'] = "-en"
		when "700:800:810"
			h['bob'] = "m1:n1"
			h['suff'] = "-en/-et"
		when "700:801:811", "702:802:812"
			h['bob'] = "m1:n2"
			h['suff'] = "-en/-et"
		when "700:703:800:801:810:811:874:875:876:877", "700:800:801:810:811"
			h['bob'] = "m1:n3"
			h['suff'] = "-en/-et"
		when "711:712", "712"
			h['bob'] = "m2"
			h['suff'] = "-eren, -ere, -erne"
		when "711:712:720:724", "711:712:721", "712:720:724", "712:717:724", "712:721:742"
			h['bob'] = "m3"
			h['suff'] = "-eren, -ere/-re/-rer, -erne/-rene"
		when "800:810"
			h['bob'] = "n1"
			h['suff'] = "-et"
		when "801:811", "802:812"
			h['bob'] = "n2"
			h['suff'] = "-et, -er, -ene/-a"
		when "800:801:810:811", "800:801:810:811:874:875:876:877", "802:804:812:814"
			h['bob'] = "n3"
			h['suff'] = "-et, -/-er, -ene/-a"
		when "700:715:900:915"
			h['bob'] = "-a/-en, -/-er, -ene"
			h['suff'] = "-a/-en, -/-er, -ene"
		when "715:915"
			h['bob'] = "-a/-en, -, -ene"
			h['suff'] = "-a/-en, -, -ene"
		when "790:990"
			h['bob'] = "-a/-en, -"
			h['suff'] = "-a/-en, -"
		when "715", "716"
			h['bob'] = "-en, -"
			h['suff'] = "-en, -"
		when "720", "721"
			h['bob'] = "-en"
			h['suff'] = "-en"
		when "725"
			h['bob'] = "-men"
			h['suff'] = "-men"
		when "780"
			h['bob'] = "m:pl"
			h['suff'] = "m:pl"
		when "790"
			h['bob'] = "m:none"
			h['suff'] = "m:none"
		when "791"
			h['bob'] = "m:def"
			h['suff'] = "m:def"
		when "700:890"
			h['bob'] = "-en::n:none"
			h['suff'] = "-en::n:none"
		when "715:800:810"
			h['bob'] = "-en, - / n1"
			h['suff'] = "-en, - / n1"
		when "790:890"
			h['bob'] = "m:n:none"
			h['suff'] = "m:n:none"
		when "810:811"
			h['bob'] = "-et, -/-er, -ene"
			h['suff'] = "-et, -/-er, -ene"
		when "801:811:850:851"
			h['bob'] = "-um, -umet/-et, -umer/-er/-a, -uma/-umene/-a/-aene"
			h['suff'] = "-um, -umet/-et, -umer/-er/-a, -uma/-umene/-a/-aene"
		when "880"
			h['bob'] = "n:pl"
			h['suff'] = "n:pl"
		when "815:816:826:827"
			h['bob'] = "-er, -eret, -er/-re, -ra/-rene"
			h['suff'] = "-er, -eret, -er/-re, -ra/-rene"
		when "890" ,"895"
			h['bob'] = "n:none"
			h['suff'] = "n:none"
		when "830:831"
			h['bob'] = "-met, -, -ma/-mene"
			h['suff'] = "-met, -, -ma/-mene"
		when "815:816:824:825"
			h['bob'] = "-d(e)ret, -der/-dre, -dra/-drene"
			h['suff'] = "-d(e)ret, -der/-dre, -dra/-drene"
		when "835:836:837:838"
			h['bob'] = "-d(de)let, -del/dler, -dla/-dlene"
			h['suff'] = "-d(de)let, -del/dler, -dla/-dlene"
		when "800:828", "835:836:841:842"
			h['bob'] = "n"
			h['suff'] = "-et"
		when "830:831"
			h['bob'] = "-met, -, -ma/-mene"
			h['suff'] = "-met, -, -ma/-mene"
		when "830:831:832:833"
			h['bob'] = "-met, -/-mer, -ma/-mene"
			h['suff'] = "-met, -/-mer, -ma/-mene"
		when "001:007:010:011:017:019", "001:010:011", "001:010", "002:012:015"
			h['bob'] = "v1"
			h['suff'] = "-et/-a"
		when "001:010:011:020", "001:010:011:021"
			h['bob'] = "v1:v2"
			h['suff'] = "-et/-a/-te"
		when "001:010:011:020:030"
			h['bob'] = "v1:v2:v3"
			h['suff'] = "-et/-a/-te/-de"
		when "001:010:011:030"
			h['bob'] = "v1:v3"
			h['suff'] = "-et/-a/-de"
		when "001:010:011:043"
			h['bob'] = "v1:v4"
			h['suff'] = "-et/-a/-dde"
		when "020"
			h['bob'] = "v2"
			h['suff'] = "-te"
		when "020:030"
			h['bob'] = "v2:v3"
			h['suff'] = "-te/-de"
		when "030"
			h['bob'] = "v3"
			h['suff'] = "-de"
		when "040", "040:041", "040:042" ,"043"
			h['bob'] = "v4"
			h['suff'] = "-dde"
		when "500"
			h['bob'] = "a1"
			h['suff'] = "-t, -e"
		when "500:504"
			h['bob'] = "a1:a2"
			h['suff'] = "-t/-, -e"
		when "504", "508"
			h['bob'] = "a2"
			h['suff'] = "-, -e"
		when "504:512", "501:503:504:512"
			h['bob'] = "a2:a3"
			h['suff'] = "-, -/-e"
		when "513", "514"
			h['bob'] = "a3"
			h['suff'] = "-, -"
		when "504:534"
			h['bob'] = "a4"
			h['suff'] = "-et, -ete/-ede"
		when "560"
			h['bob'] = "a5"
			h['suff'] = "-ent, -ne"
		end
		return h
	end

	def remove_spaces str
		output = ""
		output = str.gsub />[ \n\r\t]+</, "><"
		return output
	end

	def ==(other)
		@id == other.id
		@forms == other.forms
		@trans == other.trans
	end

end
