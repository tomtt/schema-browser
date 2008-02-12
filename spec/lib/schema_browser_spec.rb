require File.dirname(__FILE__) + '/../spec_helper'
require File.dirname(__FILE__) + '/../schema_spec_helper'

describe SchemaBrowser do
  include SchemaSpecHelper

  before(:each) do
    tables = %w{ pirates parrots }
    stub_tables(tables)
    stub_columns(tables)

    add_mock_column("pirates", "id", :type => :integer)
    add_mock_column("pirates", "name", :type => :string)
    add_mock_column("pirates", "no_key_id", :type => :string)
    add_mock_column("pirates", "quote", :type => :text)
    add_mock_column("parrots", "id", :type => :integer)
    add_mock_column("parrots", "name", :default => "parrrot", :type => :string)
    add_mock_column("parrots", "pirate_id", :type => :integer)
    add_mock_column("pirates", "parrot_id", :type => :integer)

    add_relation("parrot", "pirate")
    add_relation("pirate", "parrot")

    add_mock_index("pirates", "name")

    @browser = SchemaBrowser.new
  end

  # TODO: not sure if this may be too hard to test
  it "should be able to list all the relations"
  it "should be able to list all the tables"

  def stub_tables(tables)
    ActiveRecord::Base.connection.stub!(:tables).and_return(tables + ["schema_info"])
    # return empty array for indexes method by default
    ActiveRecord::Base.connection.stub!(:indexes).and_return([])

    @relations ||= {}

    tables.each do |table|
      eval "class #{table.classify};end"
      @relations[table] ||= []
      table_class = table.classify.constantize
      table_class.stub!(:reflect_on_all_associations).and_return(@relations[table])
      table_class.stub!(:primary_key).and_return("id")
    end
  end
end
