class ChangeLengthOfTitle < ActiveRecord::Migration
  
  def up
    change_column :posts, :title, :string, :limit => 500
  end

  def down
    change_column :posts, :title, :string
  end

end
