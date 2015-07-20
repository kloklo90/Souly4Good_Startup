class CreateProgresses < ActiveRecord::Migration
  def change
    create_table :progresses do |t|
      t.integer :level_key
      t.integer :current_value
      t.belongs_to :user, index: true

      t.timestamps
    end
  end
end
