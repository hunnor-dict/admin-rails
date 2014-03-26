#encoding: utf-8
class Dictionary

	def hits
		h = {}
		database = Database.new
		db = database.db
		sql = "SELECT COUNT(1) AS n FROM logSearch";
		res = db.query sql
		res.each do |row|
			h["total"] = row["n"]
		end
		sql = "SELECT COUNT(1) AS n FROM logSearch WHERE qRes = 1";
		res = db.query sql
		res.each do |row|
			h["found"] = row["n"]
		end
		return h
	end

	def missing
		a = []
		database = Database.new
		db = database.db
		sql = "SELECT qTerm, COUNT(1) AS n FROM logSearch WHERE qRes = 0 GROUP BY qTerm ORDER BY n DESC LIMIT 50"
		res = db.query sql
		res.each do |row|
			h = {:term => row["qTerm"], :n => row["n"]}
			a.push h
		end
		return a
	end

	def searches
		a = []
		database = Database.new
		db = database.db
		sql = "SELECT qTerm, COUNT(1) AS n FROM logSearch GROUP BY qTerm ORDER BY n DESC LIMIT 50"
		res = db.query sql
		res.each do |row|
			h = {:term => row["qTerm"], :n => row["n"]}
			a.push h
		end
		return a
	end

	def stats
		h = {}
		langs = [:hu, :nb]
		database = Database.new
		db = database.db
		columns = database.columns
		langs.each do |lang|
			tables = database.tables lang
			sql = "SELECT COUNT(DISTINCT #{columns[:forms][:id]}) AS n FROM #{tables[:forms]} WHERE "
			sql += "#{columns[:forms][:status]} > 0"
			res = db.query sql
			res.each do |row|
				h.store lang, row["n"]
			end
		end
		return h
	end

	def suggest term
		suggestions = {}
		langs = [:hu, :nb]
		langs.each do |lang|
			lang_suggestions = suggest_lang lang, term
			lang_suggestions.each do |lang_suggestion|
				if suggestions.has_key? lang_suggestion
					s = suggestions[lang_suggestion]
					lang_a = s["lang"]
					lang_a.push lang
				else
					suggestions[lang_suggestion] = {"value" => lang_suggestion, "lang" => [lang]}
				end
			end
		end
		suggestions = suggestions.sort
		sg = []
		suggestions.each do |key, val|
			sg.push val
			if sg.size >= 20
				break
			end
		end
		sg
	end

	def suggest_lang lang, term
		limit = 20
		suggestions = []
		database = Database.new
		db = database.db
		columns = database.columns
		tables = database.tables lang
		sql = "SELECT DISTINCT #{columns[:forms][:orth]} FROM #{tables[:forms]} WHERE "
		sql += "#{columns[:forms][:orth]} LIKE '#{term}%' AND #{columns[:forms][:status]} > 0 "
		sql += "AND #{columns[:forms][:seq]} = 1 ORDER BY #{columns[:forms][:orth]} LIMIT #{limit}"
		res = db.query sql
		res.each do |row|
			suggestions.push row[columns[:forms][:orth]]
		end
		suggestions
	end

	def search term, match
		entries = {}
		langs = [:hu, :nb]
		res = "0"
		langs.each do |lang|
			entries[lang] = search_lang lang, term, match
			if !entries[lang].empty?
				res = "1"
			end
		end
		database = Database.new
		db = database.db
		sql = "INSERT INTO logSearch (qTerm, qRes, qSrc) VALUES ('#{term}', '#{res}', '')"
		db.query sql
		entries
	end

	def search_lang lang, term, match
		database = Database.new
		db = database.db
		columns = database.columns
		tables = database.tables lang
		match_condition = ""
		if match == "root"
			match_condition = " AND #{columns[:forms][:seq]} = 1"
		end
		entries = {}
		matches = []
		sql = "SELECT DISTINCT #{columns[:forms][:entry]} FROM #{tables[:forms]} WHERE "
		sql += "#{columns[:forms][:orth]} LIKE '#{term}' AND #{columns[:forms][:status]} > 0#{match_condition}"
		res = db.query sql
		res.each do |row|
			matches.push row[columns[:forms][:entry]]
		end
		if matches.empty?
			return []
		end

		sql = "SELECT * FROM #{tables[:forms]} WHERE "
		sql += "#{columns[:forms][:entry]} IN (#{matches.join(', ')}) "
		sql += "ORDER BY #{columns[:forms][:id]}, #{columns[:forms][:par]}, #{columns[:forms][:seq]}"
		pos = nil
		res = db.query sql
		res.each do |row|
			id = row[columns[:forms][:id]]
			entry = row[columns[:forms][:entry]]
			orth = row[columns[:forms][:orth]]
			pos = row[columns[:forms][:pos]]
			par = row[columns[:forms][:par]]
			seq = row[columns[:forms][:seq]]
			status = row[columns[:forms][:status]]
			entry_h = {}
			if entries[entry].nil?
				entries[entry] = entry_h
			else
				entry_h = entries[entry]
			end
			if entry_h["id"].nil?
				entry_h["id"] = entry
			end
			if entry_h["pos"].nil?
				entry_h["pos"] = pos
			end
			if entry_h["status"].nil?
				entry_h["status"] = status
			end
			entries[entry]["id"] = entry
			if id == entry
				if entry_h["forms"].nil?
					entry_h["forms"] = {}
				end
				forms_h = entry_h["forms"]
				if forms_h[par].nil?
					forms_h[par] = {}
				end
				par_h = forms_h[par]
				par_h[seq] = orth
			else
				if entry_h["alt"].nil?
					entry_h["alt"] = {}
				end
				alt_h = entry_h["alt"]
				if alt_h[id].nil?
					alt_h[id] = {}
				end
				id_h = alt_h[id]
				if id_h[par].nil?
					id_h[par] = {}
				end
				alt_par_h = id_h[par]
				alt_par_h[seq] = orth
			end
		end
		if $xsl.nil?
			$xsl = Nokogiri::XSLT(File.read("#{Rails.root.join("public", "hunnor-trans.xsl")}"))
		end
		sql = "SELECT * FROM #{tables[:trans]} WHERE #{columns[:trans][:id]} IN (#{matches.join(", ")})"
		res = db.query sql
		res.each do |row|
			id = row[columns[:trans][:id]]
			trans = row[columns[:trans][:trans]]
			trans_dom = Nokogiri::XML("<entry>#{trans}</trans>")
			html = $xsl.transform(trans_dom)
			entries[id]["trans"] = html.to_xml(
				:save_with => Nokogiri::XML::Node::SaveOptions::NO_DECLARATION | Nokogiri::XML::Node::SaveOptions::AS_XML)
				.gsub(/\n[ ]+/, "")
		end

		entries.values
	end

	def lookup
		database = Database.new
		db = database.db
		columns = database.columns
		conditions = {}
		entries = []
		@lang.each do |lang_group_key, lang_group_val|
			lang_group_val.each do |lang_key, lang_val|
				tables = database.tables lang_key
				if !@letter.nil?
					letters = def_letters
					condition = letters[lang_key][@letter]
					if !condition.nil?
						conditions[:orth] = " #{condition}"
					end
				end
				if !@term.nil?
					conditions[:orth] = " #{columns[:forms][:orth]} LIKE '#{@term}%'"
				end
				case @stat
				when "1"
					conditions[:status] = " AND #{columns[:forms][:status]} > 0"
				end
				if !conditions[:orth].nil?
					sql = "SELECT DISTINCT #{columns[:forms][:id]} FROM #{tables[:forms]} WHERE "
					conditions.each do |ckey, condition|
						sql = sql + condition
					end
					sql = sql + " AND #{columns[:forms][:seq]} = 1 ORDER BY #{columns[:forms][:orth]}"
					if !@limit.nil?
						sql = sql + " LIMIT #{@limit}"
					end
					res = db.query sql
					res.each do |row|
						entry = Entry.new lang_key, row[columns[:forms][:id]], nil, nil
						entries.push entry
					end
				end
			end
		end
		database.close
		entries
	end

	def set_lang lang
		case lang
		when Array
			@lang = {}
			lang.each do |l|
				case l
				when "hu"
					@lang[:hu] = {:hu => true}
				when "nb"
					if @lang[:no].nil?
						@lang[:no] = {:nb => true}
					else
						@lang[:no][:nb] = true
					end
				when "nn"
					if @lang[:no].nil?
						@lang[:no] = {:nn => true}
					else
						@lang[:no][:nn] = true
					end
				end
			end
		end
	end

	def lang
		@lang
	end

	def set_letter letter
		@letter = letter
	end

	def letter
		@letter
	end

	def set_term term
		@term = term
	end

	def term
		@term
	end

	def set_stat stat
		case stat
		when "1"
			@stat = "1"
		end
	end

	def stat
		@stat
	end

	def set_limit limit
		limit = limit.to_i
		case limit
		when 1..20
			@limit = limit
		end
	end

	def limit
		@limit
	end

	def def_letters
		letters = {
			:hu => {
				"a" => "orth LIKE 'a%'",
				"b" => "orth LIKE 'b%'",
				"c" => "orth LIKE 'c%' AND orth NOT LIKE 'cs%'",
				"cs" => "orth LIKE 'cs%'",
				"d" => "orth LIKE 'd%' AND orth NOT LIKE 'dz'",
				"dz" => "orth LIKE 'dz%' AND orth NOT LIKE 'dzs'",
				"dzs" => "orth LIKE 'dzs%'",
				"e" => "orth LIKE 'e%'",
				"f" => "orth LIKE 'f%'",
				"g" => "orth LIKE 'g%' AND orth NOT LIKE 'gy%'",
				"gy" => "orth LIKE 'gy%'",
				"h" => "orth LIKE 'h%'",
				"i" => "orth LIKE 'i%'",
				"j" => "orth LIKE 'j%'",
				"k" => "orth LIKE 'k%'",
				"l" => "orth LIKE 'l%' AND orth NOT LIKE 'ly%'",
				"ly" => "orth LIKE 'l%'",
				"m" => "orth LIKE 'm%'",
				"n" => "orth LIKE 'n%' AND orth NOT LIKE 'ny%'",
				"ny" => "orth LIKE 'ny%'",
				"o" => "orth LIKE 'o%'",
				"oe" => "orth LIKE 'ö%'",
				"p" => "orth LIKE 'p%'",
				"q" => "orth LIKE 'q%'",
				"r" => "orth LIKE 'r%'",
				"s" => "orth LIKE 's%' AND orth NOT LIKE 'sz%'",
				"sz" => "orth LIKE 'sz%'",
				"t" => "orth LIKE 't%' AND orth NOT LIKE 'ty%'",
				"ty" => "orth LIKE 'ty%'",
				"u" => "orth LIKE 'u%'",
				"ue" => "orth LIKE 'ü%'",
				"v" => "orth LIKE 'v%'",
				"w" => "orth LIKE 'w%'",
				"x" => "orth LIKE 'x%'",
				"y" => "orth LIKE 'y%'",
				"z" => "orth LIKE 'z%' AND orth NOT LIKE 'zs%'",
				"zs" => "orth LIKE 'zs%'"
			},
			:nb => {
				"a" => "orth LIKE 'a%'",
				"b" => "orth LIKE 'b%'",
				"c" => "orth LIKE 'c%'",
				"d" => "orth LIKE 'd%'",
				"e" => "orth LIKE 'e%'",
				"f" => "orth LIKE 'f%'",
				"g" => "orth LIKE 'g%'",
				"h" => "orth LIKE 'h%'",
				"i" => "orth LIKE 'i%'",
				"j" => "orth LIKE 'j%'",
				"k" => "orth LIKE 'k%'",
				"l" => "orth LIKE 'l%'",
				"m" => "orth LIKE 'm%'",
				"n" => "orth LIKE 'n%'",
				"o" => "orth LIKE 'o%'",
				"p" => "orth LIKE 'p%'",
				"q" => "orth LIKE 'q%'",
				"r" => "orth LIKE 'r%'",
				"s" => "orth LIKE 's%'",
				"t" => "orth LIKE 't%'",
				"u" => "orth LIKE 'u%'",
				"v" => "orth LIKE 'v%'",
				"w" => "orth LIKE 'w%'",
				"x" => "orth LIKE 'x%'",
				"y" => "orth LIKE 'y%'",
				"z" => "orth LIKE 'z%'",
				"ae" => "orth LIKE 'æ%'",
				"oe" => "orth LIKE 'ø%'",
				"aa" => "orth LIKE 'å%'"
			}
		}
		letters
	end

end

