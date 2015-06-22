class CreateMiscs < ActiveRecord::Migration

	def migrate(direction)
		super
		if direction == :up
			Misc.create name: "reddit_last_update", value: 0
		end
	end
  def change
    create_table :miscs do |t|
    	t.string :name
    	t.integer :value
      t.timestamps
    end
  end
end
