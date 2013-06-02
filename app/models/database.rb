#encoding: utf-8
class Database

	attr_accessor :db

	def initialize
		@db = Mysql2::Client.new(:host => ENV["DB_MYSQL_HOST"], :username => ENV["DB_MYSQL_USER"], :password => ENV["DB_MYSQL_PASS"], :database => ENV["DB_MYSQL_DB"])
	end

	def close
		@db.close
	end

	def tables lang
		case lang
		when :hu
			return {:forms => "hn_hun_segment", :trans => "hn_hun_tr_nob_tmp"}
		when :nb
			return {:forms => "hn_nob_segment", :trans => "hn_nob_tr_hun_tmp"}
		when :nn
			return {:forms => "hn_nn_forms", :trans => "hn_nn_trans"}
		else
			return nil
		end
	end

	def columns
		return {
			:forms => {:id => "id", :entry => "entry", :orth => "orth", :pos => "pos", :par => "par", :seq => "seq", :status => "status"},
			:trans => {:id => "id", :trans => "trans"}
		}
	end

	def editors
		return {
			:table => "hn_adm_editors",
			:id => "id",
			:provider => "provider",
			:uid => "uid"
		}
	end

end

