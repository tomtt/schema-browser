require File.dirname(__FILE__) + '/../spec_helper'

describe SchemaBrowser do
  before(:each) do
    @tables = %w{ pirates parrots }
    stub_tables
    stub_columns
  end

  it "should produce xml with simple instruct" do
    SchemaBrowser.database_tables_to_xml.split("\n")[0].should ==
      '<?xml version="1.0" ?>'
  end

  it "should have a table tag wrapped in an sql tag" do
    SchemaBrowser.database_tables_to_xml.should have_tag("sql") do
      with_tag("table")
    end
  end

  it "should have table tags for each table" do
    SchemaBrowser.database_tables_to_xml.should have_tag("sql") do
      @tables.each do |table|
        with_tag("table[title=?]", table)
      end
    end
  end

  it "should assign a unique id to each table" do
    SchemaBrowser.database_tables_to_xml.should have_tag("sql") do
      @tables.size.times do |i|
        with_tag("table[id=?]", i)
      end
    end
  end

  it "should assign an x position to tables" do
    SchemaBrowser.database_tables_to_xml.should have_tag("table[x]")
  end

  it "should assign an y position to tables" do
    SchemaBrowser.database_tables_to_xml.should have_tag("table[y]")
  end

  # Columns
  it "should add a tag to a table tag for each database column"
  it "should assign a unique id to each column"
  it "should set the pk attribute if the column is a public key"
  it "should set the index attribute if the column is a public key"
  it "should add the name of the column in a title tag"
  it "should add the default value of the column in a default tag"
  it "should add the type of the column in a type tag"

  # Relations
  it "should generate a relation for each belongs_to model relation"
  it "should add the id of the table containing the foreign key in a table_1 tag"
  it "should add the id of the column containing the foreign key in a row_1 tag"
  it "should add the id of the table referenced by the foreign key in a table_2 tag"
  it "should add the id of the column referenced by the foreign key in a row_2 tag"

  def stub_tables
    ActiveRecord::Base.connection.stub!(:tables).and_return(@tables)
  end

  def stub_columns
    @stubbed_columns = []
    ActiveRecord::Base.connection.stub!(:columns).and_return(@stubbed_columns)
  end
end
