#encoding: utf-8
class Dictionary

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
					conditions[:orth] = " #{columns[:forms][:orth]} LIKE '#{db.escape(@term)}%'"
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
				"a" => "(orth LIKE 'a%' OR orth LIKE 'á%')",
				"b" => "orth LIKE 'b%'",
				"c" => "(orth LIKE 'c%' AND orth NOT LIKE 'cs%')",
				"cs" => "orth LIKE 'cs%'",
				"d" => "(orth LIKE 'd%' AND orth NOT LIKE 'dz%')",
				"dz" => "(orth LIKE 'dz%' AND orth NOT LIKE 'dzs%')",
				"dzs" => "orth LIKE 'dzs%'",
				"e" => "(orth LIKE 'e%' OR orth LIKE 'é%')",
				"f" => "orth LIKE 'f%'",
				"g" => "(orth LIKE 'g%' AND orth NOT LIKE 'gy%')",
				"gy" => "orth LIKE 'gy%'",
				"h" => "orth LIKE 'h%'",
				"i" => "(orth LIKE 'i%' OR orth LIKE 'í%')",
				"j" => "orth LIKE 'j%'",
				"k" => "orth LIKE 'k%'",
				"l" => "(orth LIKE 'l%' AND orth NOT LIKE 'ly%')",
				"ly" => "orth LIKE 'ly%'",
				"m" => "orth LIKE 'm%'",
				"n" => "(orth LIKE 'n%' AND orth NOT LIKE 'ny%')",
				"ny" => "orth LIKE 'ny%'",
				"o" => "(orth LIKE 'o%' OR orth LIKE 'ó%')",
				"oe" => "(orth LIKE 'ö%' OR orth LIKE 'ő%')",
				"p" => "orth LIKE 'p%'",
				"q" => "orth LIKE 'q%'",
				"r" => "orth LIKE 'r%'",
				"s" => "(orth LIKE 's%' AND orth NOT LIKE 'sz%')",
				"sz" => "orth LIKE 'sz%'",
				"t" => "(orth LIKE 't%' AND orth NOT LIKE 'ty%')",
				"ty" => "orth LIKE 'ty%'",
				"u" => "(orth LIKE 'u%' OR orth LIKE 'ú%')",
				"ue" => "(orth LIKE 'ü%' OR orth LIKE 'ű%')",
				"v" => "orth LIKE 'v%'",
				"w" => "orth LIKE 'w%'",
				"x" => "orth LIKE 'x%'",
				"y" => "orth LIKE 'y%'",
				"z" => "(orth LIKE 'z%' AND orth NOT LIKE 'zs%')",
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

	def get_orth_max lang
		orth_max = {}
		database = Database.new
		db = database.db
		tables = database.tables lang
		letters = def_letters
		lang_letters = letters[lang]
		lang_letters.each do |lang_letter, letter_sql|
			sql = "SELECT DISTINCT entry FROM #{tables[:forms]} WHERE status > 0 AND #{letter_sql} AND seq < 2 AND id = entry ORDER BY orth"
			res = db.query sql
			res.each do |row|
				entry = row["entry"]
				sql2 = "SELECT id, orth FROM #{tables[:forms]} WHERE entry = '#{entry}' AND status > 0 AND seq = '1' GROUP BY id"
				res2 = db.query sql2
				res2.each do |row2|
					orth = row2["orth"]
					if orth_max[orth].nil?
						orth_max[orth] = 1
					else
						orth_max[orth] = orth_max[orth] + 1
					end
				end
			end
		end
		database.close
		return orth_max
	end

	def export_hu out_dir
		orth_max = get_orth_max :hu
		orth_count = {}
		file = File.open "#{out_dir}/HunNor-XML-HN.xml", "w"
		database = Database.new
		db = database.db
		file.write "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n";
		date = Time.now.strftime "%Y-%m-%d"
		file.write "<hnDict xmlns=\"http://dict.hunnor.net\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" updated=\"#{date}\" xsi:schemaLocation=\"http://dict.hunnor.net hunnor.net.Schema.HN.xsd\">\n";
		letters = def_letters
		hu_letters = letters[:hu]
		hu_letters.each do |hu_letter, letter_sql|
			letter = hu_letter
			if letter == "oe"
				letter = "Ö"
			elsif letter == "ue"
				letter = "Ü"
			else
				letter = letter.upcase
			end
			file.write "\t<entryGrp head=\"#{letter}\">\n"
			sql = "SELECT DISTINCT entry, CASE pos WHEN 'fn' THEN '1' WHEN 'ige' THEN '2' WHEN 'mn' THEN '3' ELSE '99' END AS pos_key FROM hn_hun_segment WHERE #{letter_sql} AND status > 0 AND id = entry ORDER BY orth, pos_key, pos, entry"
			res = db.query sql
			res.each do |row|
				entry_id = row["entry"]
				entry = Entry.new :hu, entry_id, {:trans => true}, nil
				doc = entry.to_xml_doc
				entry_tag = doc.at "/h:hnDict/h:entryGrp/h:entry", {"h" => "http://dict.hunnor.net"}
				orth_tags = entry_tag.xpath "h:formGrp/h:form/h:orth", {"h" => "http://dict.hunnor.net"}
				orth_tags.each do |orth_tag|
					orth = orth_tag.content
					max = orth_max[orth]
					if max > 1
						count = orth_count[orth]
						if orth_count[orth].nil?
							orth_count[orth] = 1
						else
							orth_count[orth] = orth_count[orth] + 1
						end
						orth_tag.set_attribute "n", orth_count[orth].to_s
					else
						orth_tag.set_attribute "n", "0"
					end
				end
				entry_s = entry_tag.to_xml
				lines_to_add = ""
				entry_s.each_line do |line|
					line = "\t\t" + line
					line.gsub! "\r", ""
					line.gsub! "  ", "\t"
					lines_to_add += line
				end
				file.write lines_to_add
				file.write "\n"
			end
			file.write "\t</entryGrp>\n"
		end
		file.write "</hnDict>\n"
		file.close
		database.close
	end

	def export_nb out_dir
		orth_max = get_orth_max :nb
		orth_count = {}
		file = File.open "#{out_dir}/HunNor-XML-NH.xml", "w"
		database = Database.new
		db = database.db
		file.write "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n";
		date = Time.now.strftime "%Y-%m-%d"
		file.write "<hnDict xmlns=\"http://dict.hunnor.net\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" updated=\"#{date}\" xsi:schemaLocation=\"http://dict.hunnor.net hunnor.net.Schema.NH.xsd\">\n";
		letters = def_letters
		no_letters = letters[:nb]
		no_letters.each do |no_letter, letter_sql|
			letter = no_letter
			if letter == "ae"
				letter = "Æ"
			elsif letter == "oe"
				letter = "Ø"
			elsif letter  == "aa"
				letter = "Å"
			else
				letter = letter.upcase
			end
			file.write "\t<entryGrp head=\"#{letter}\">\n"
			sql = "SELECT entry, CASE pos WHEN 'subst' THEN '1' WHEN 'verb' THEN '2' WHEN 'adj' THEN '3' ELSE '99' END AS pos_key FROM hn_nob_segment WHERE #{letter_sql} AND status > 0 AND seq < 2 AND id = entry GROUP BY entry ORDER BY orth, pos_key, pos, entry"
			res = db.query sql
			res.each do |row|
				entry_id = row["entry"]
				entry = Entry.new :nb, entry_id, {:trans => true}, nil
				doc = entry.to_xml_doc
				entry_tag = doc.at "/h:hnDict/h:entryGrp/h:entry", {"h" => "http://dict.hunnor.net"}
				orth_tags = entry_tag.xpath "h:formGrp/h:form/h:orth", {"h" => "http://dict.hunnor.net"}
				orth_tags.each do |orth_tag|
					orth = orth_tag.content
					max = orth_max[orth]
					if max.nil?
						file.write "<!-- null counter for #{orth} (#{entry_id}) -->\n"
					end
					if !max.nil? && max > 1
						count = orth_count[orth]
						if orth_count[orth].nil?
							orth_count[orth] = 1
						else
							orth_count[orth] = orth_count[orth] + 1
						end
						orth_tag.set_attribute "n", orth_count[orth].to_s
					else
						orth_tag.set_attribute "n", "0"
					end
				end
				entry_s = entry_tag.to_xml
				lines_to_add = ""
				entry_s.each_line do |line|
					line = "\t\t" + line
					line.gsub! "\r", ""
					line.gsub! "  ", "\t"
					lines_to_add += line
				end
				file.write lines_to_add
				file.write "\n"
			end
			file.write "\t</entryGrp>\n"
		end
		file.write "</hnDict>\n"
		file.close
		database.close
	end

end
