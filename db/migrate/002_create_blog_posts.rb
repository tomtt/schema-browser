class CreateBlogPosts < ActiveRecord::Migration
  def self.up
    create_table :blog_posts do |t|
      t.references :user
      t.string :title
      t.text :content

      t.timestamps
    end
  end

  def self.down
    drop_table :blog_posts
  end
end
