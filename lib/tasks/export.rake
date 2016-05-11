def export_xml lang, out_dir
	dictionary = Dictionary.new
	if lang == "nb"
		dictionary.export_nb out_dir
	elsif lang == "hu"
		dictionary.export_hu out_dir
	end
end

namespace :hn do

	desc "Export articles as XML"
	task :articles, [:norm, :id, :min_status, :tr_lang, :single_file] => :environment do |t, args|
		export_articles args[:norm], args[:id], args[:min_status], args[:tr_lang], args[:single_file]
	end

	desc "Export to XML"
	task :export, [:lang, :out_dir] => :environment do |t, args|
		export_xml args[:lang], args[:out_dir]
	end

end
