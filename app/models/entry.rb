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
			eXistenZ_res = db.query "SELECT #{columns[:forms][:id]} FROM #{tables[:forms]} WHERE #{columns[:forms][:id]} = '#{db.escape(@id)}'"
			if eXistenZ_res.count == 0
				@exists = false
				database.close
				return
			else
				@exists = true
			end
			@forms = {}
			res = db.query "SELECT * FROM #{tables[:forms]} WHERE #{columns[:forms][:id]} = '#{db.escape(@id)}' ORDER BY #{columns[:forms][:par]}, #{columns[:forms][:seq]}"
			res.each do |row|
				if @form.nil?
					@form = row[columns[:forms][:orth]]
				end
				@entry = row[columns[:forms][:entry]]
				@pos = row[columns[:forms][:pos]]
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
					res = db.query "SELECT #{columns[:trans][:trans]} FROM #{tables[:trans]} WHERE #{columns[:trans][:id]} = '#{db.escape(@id)}'"
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
		entry_res = db.query("SELECT #{columns[:forms][:entry]} FROM #{tables[:forms]} WHERE #{columns[:forms][:entry]} = '#{db.escape(entry)}'")
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
		trans_string = "<senseValidation xmlns=\"http://dict.hunnor.net\">" + trans + "</senseValidation>"
		trans_xml = Nokogiri::XML trans_string
		xml_errors += trans_xml.errors
		sense_schema = Nokogiri::XML::Schema(File.read(Rails.root.to_s + "/public/port/xml/hunnor.net.Schema.xsd"))
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
			forms_new.each do |par_key, par_val|
				par_val.each do |seq_key, seq_val|
					sql.push "INSERT INTO #{tables[:forms]} (#{columns[:forms][:id]}, #{columns[:forms][:entry]}, #{columns[:forms][:orth]}, #{columns[:forms][:pos]}, #{columns[:forms][:par]}, #{columns[:forms][:seq]}, #{columns[:forms][:status]}) VALUES('#{@id}', '#{@entry}', '#{db.escape(seq_val)}', '#{db.escape(values[:pos])}', '#{db.escape(par_key)}', '#{db.escape(seq_key)}', '#{db.escape(values[:status])}')"
				end
			end
		else
			action = "update"
			form_global_changes = []
			if @entry != values[:entry].to_i
				form_global_changes.push "#{columns[:forms][:entry]} = '#{db.escape(values[:entry])}'"
				@entry = values[:entry]
			end
			if @pos != values[:pos]
				form_global_changes.push "#{columns[:forms][:pos]} = '#{db.escape(values[:pos])}'"
				@pos = values[:pos]
			end
			if @status != values[:status].to_i
				form_global_changes.push "#{columns[:forms][:status]} = '#{db.escape(values[:status])}'"
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
				sql.push "DELETE FROM #{tables[:forms]} WHERE #{columns[:forms][:id]} = '#{@id}' AND #{columns[:forms][:par]} = '#{db.escape(rm_a[0])}' AND #{columns[:forms][:seq]} = '#{db.escape(rm_a[1])}' AND #{columns[:forms][:orth]} = '#{db.escape(rm_a[2])}'"
			end
			added_forms.each do |added_form|
				add_a = added_form.split ";"
				sql.push "INSERT INTO #{tables[:forms]} (#{columns[:forms][:id]}, #{columns[:forms][:entry]}, #{columns[:forms][:orth]}, #{columns[:forms][:pos]}, #{columns[:forms][:par]}, #{columns[:forms][:seq]}, #{columns[:forms][:status]}) VALUES ('#{@id}', '#{@entry}', '#{db.escape(add_a[2])}', '#{db.escape(values[:pos])}', '#{db.escape(add_a[0])}', '#{db.escape(add_a[1])}', '#{db.escape(values[:status])}')"
			end
		end

		# validate and update translation
		trans_errors = validate_trans values[:trans]
		if trans_errors.empty?
			if values[:trans] != @trans
				if action == "update"
					trans_check_res = db.query "SELECT id FROM #{tables[:trans]} WHERE id = '#{db.escape(@id)}'"
					if trans_check_res.size == 0
						sql.push "INSERT INTO #{tables[:trans]} (#{columns[:trans][:id]}, #{columns[:trans][:trans]}) VALUES ('#{db.escape(@id)}', '#{db.escape(values[:trans])}')"
					else
						sql.push "UPDATE #{tables[:trans]} SET #{columns[:trans][:trans]} = '#{db.escape(values[:trans])}' WHERE #{columns[:trans][:id]} = '#{db.escape(id)}'"
					end
				else
					sql.push "INSERT INTO #{tables[:trans]} (#{columns[:trans][:id]}, #{columns[:trans][:trans]}) VALUES ('#{db.escape(@id)}', '#{db.escape(values[:trans])}')"
				end
			end
		else
			errors += trans_errors
		end

		# execute queries if no errors
		if errors.empty?
			# add edit log entry
			clock = Time.new
			timestamp = clock.strftime("%Y%m%d%H%M%S")
			sql.push "INSERT INTO hn_log_edit (editor_id, lang, entry_id, action, timestamp) VALUES ('#{editor}', '#{@lang}', '#{id}', '#{action}', '#{timestamp}')"
			sql.each do |sql_query|
				db.query sql_query
			end
		end

		# return errors and queries
		ret_value = {:errors => errors, :sql => sql}
		db.close
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
		case mode
		when :deprecated
			link = "http://www.dokpro.uio.no/perl/ordboksoek/ordbok.cgi?OPP=#{@form}&ordbok=bokmaal&s=n&alfabet=e&renset=j"
		when :fallback
			link = "http://www.dokpro.uio.no/perl/ordboksoek/ordbok_retro.cgi?OPP=#{@form}&bokmaal=S%F8k+i+Bokm%E5lsordboka&ordbok=bokmaal&alfabet=e&renset=j"
		else
			link = "http://www.nob-ordbok.uio.no/perl/ordbok.cgi?OPP=#{@form}&bokmaal=+&ordbok=begge"
		end
	end
	
	def ==(other)
		@id == other.id
		@forms == other.forms
		@trans == other.trans
	end

end

