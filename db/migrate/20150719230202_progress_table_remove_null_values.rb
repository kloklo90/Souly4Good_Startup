class ProgressTableRemoveNullValues < ActiveRecord::Migration
  def change
  	change_column :progresses, :level_key, :integer,  :null => false, :default => 0
  	change_column :progresses, :current_value, :integer,  :null => false, :default => 0
  end
end
