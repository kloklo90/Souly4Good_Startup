class AddPostTypeToPost < ActiveRecord::Migration
  def change
    add_column :posts, :post_type, :string
    add_column :posts, :external, :boolean, default: false
    add_column :posts, :external_author, :string
    add_column :posts, :external_author_url, :string
    
    add_index :posts, :post_type
  end
end
