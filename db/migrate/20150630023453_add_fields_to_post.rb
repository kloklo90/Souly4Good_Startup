class AddFieldsToPost < ActiveRecord::Migration
	def migrate(direction)
		if direction == :up 			
			Post.all.map{ |p| p.update_attributes(post_type:  "external") }
		end
		super
	end
  def change
  	add_column :posts, :expiry_date, :datetime
  	add_column :posts, :admin, :boolean, default: false

  end
end
