class CreateLevels < ActiveRecord::Migration
  def change
    create_table :levels do |t|
      t.integer :key
      t.string :name

      t.timestamps
    end
  end
end
