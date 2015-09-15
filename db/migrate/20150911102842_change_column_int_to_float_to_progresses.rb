class ChangeColumnIntToFloatToProgresses < ActiveRecord::Migration

  def up
    change_column :progresses, :current_value, :float
  end

  def down
    change_column :progresses, :current_value, :integer
  end

end
