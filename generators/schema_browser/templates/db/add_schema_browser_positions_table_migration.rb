class AddSchemaBrowserPositionsTable < ActiveRecord::Migration
  def self.up
    create_table :schema_browser_table_properties do |t|
      t.string :table_name, :x_pos, :y_pos
      t.boolean :collapsed, :shown
      t.timestamps
    end
  end

  def self.down
    drop_table :schema_browser_table_properties
  end
end
