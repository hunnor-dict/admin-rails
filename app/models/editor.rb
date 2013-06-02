#encoding: utf-8
class Editor

	attr_accessor :id, :provider, :uid

	def initialize provider, uid
		@id = nil
		@provider = provider
		@uid = uid
		database = Database.new
		db = database.db
		editors = database.editors
		res = db.query "SELECT #{editors[:id]} FROM #{editors[:table]} WHERE #{editors[:provider]} = '#{@provider}' AND #{editors[:uid]} ='#{@uid}'"
		res.each do |row|
			@id = row[editors[:id]]
		end
		database.close
	end

	def authorized?
		@id != nil
	end

end

