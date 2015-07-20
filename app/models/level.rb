class Level < ActiveRecord::Base

	def self.getLevel(val)
		self.where(key: val).first.name
	end
end
