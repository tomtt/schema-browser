require File.dirname(__FILE__) + '/../spec_helper'
require File.dirname(__FILE__) + '/../schema_spec_helper'

describe SchemaTable do
  include SchemaSpecHelper

  # We are stubbing out all the bits where info about tables, columns, relations and
  # indexes resides. It should be fine to do this only once at the beginning for all
  # specs since the code should only read the schema and leave it alone otherwise.
  before(:all) do
    @tables = %w{ pirates parrots relationships}
    stub_tables(@tables)
    stub_columns(@tables)

    add_mock_column("pirates", "id", :type => :integer)
    add_mock_column("pirates", "name", :type => :string)
    add_mock_column("pirates", "no_key_id", :type => :string)
    add_mock_column("pirates", "quote", :type => :text)
    add_mock_column("parrots", "id", :type => :integer)
    add_mock_column("parrots", "name", :default => "parrrot", :type => :string)
    add_mock_column("parrots", "pirate_id", :type => :integer)

    add_mock_column("relationships", "one_id", :type => :integer)
    add_mock_column("relationships", "two_id", :type => :integer)

    add_relation("parrot", "pirate")

    add_mock_index("pirates", "name")
    add_mock_index("parrots", "non_existing_column") # FIXME: this should be done just in the test that checks for error on non existing column
  end

  before(:each) do
    @pirates_table = SchemaTable.new("pirates")
    @parrots_table = SchemaTable.new("parrots")
    @relationships_table = SchemaTable.new("relationships")
    @pirates_table.gather_relations
    @parrots_table.gather_relations
    @relationships_table.gather_relations
  end

  it "should return a column by its name" do
    @pirates_table.column("quote").name.should == "quote"
  end

  it "should assign a unique id to each new instance" do
    @pirates_table.table_id.should_not == @parrots_table.table_id
  end

  it "should return all of its columns" do
    @pirates_table.columns.map(&:name).should include("id", "name", "no_key_id", "quote")
  end

  it "should set the title in the attributes to its name" do
    @pirates_table.attributes[:title].should == "pirates"
  end

  it "should set the id in the attributes to a string of its table_id" do
    @pirates_table.attributes["id"].should == @pirates_table.table_id.to_s
  end

  it "should set a value for x in the attributes" do
    pending "for now not specifying position is actually the better option" do
      @pirates_table.attributes.should have_key("x")
    end
  end

  it "should set a value for y in the attributes" do
    pending "for now not specifying position is actually the better option" do
      @pirates_table.attributes.should have_key("y")
    end
  end

  it "should set its primary key" do
    @pirates_table.column("id").primary_key.should == true
  end

  it "should not set any other columns as primary key" do
    non_primary_names = @pirates_table.columns.map(&:name)
    non_primary_names.delete("id")
    non_primary_names.each do |col|
      @pirates_table.column(col).primary_key.should_not == true
    end
  end

  it "should set index of fields that it has an index on" do
    @pirates_table.column("name").index.should == true
  end

  it "should not set index of fields that it has no index on" do
    non_index_names = @pirates_table.columns.map(&:name)
    non_index_names.delete("name")
    non_index_names.each do |col|
      @pirates_table.column(col).index.should_not == true
    end
  end

  it "should set foreign key on columns that a belongs_to relation is defined on" do
    @parrots_table.column("pirate_id").foreign_key.should == true
  end

  it "should not set foreign key on columns that no belongs_to relation is defined on" do
    non_foreign_names = @parrots_table.columns.map(&:name)
    non_foreign_names.delete("pirate_id")
    non_foreign_names.each do |col|
      @parrots_table.column(col).foreign_key.should_not == true
    end
  end

  it "should return its primary key column if set" do
    @pirates_table.primary_key_column.name.should == "id"
  end

  it "should return a reflection with the origin_table_id set to its own when creating a relation" do
    @parrots_table.relations.first.origin_table_id.should == @parrots_table.table_id
  end

  it "should return a reflection with the origin_row_id set to its foreign key when creating a relation" do
    @parrots_table.relations.first.origin_row_id.should == @parrots_table.column("pirate_id").column_id
  end

  it "should return a reflection with the destination_table_id set to the table_id of the referenced table when creating a relation" do
    @parrots_table.relations.first.destination_table_id.should == @pirates_table.table_id
  end

  it "should return a reflection with the destination_row_id set to the column_id of the primary key of the referenced table when creating a relation" do
    @parrots_table.relations.first.destination_row_id.should == @pirates_table.primary_key_column.column_id
  end

  it "should return nil for its primary key column if the table has no pk" do
    @relationships_table.primary_key_column.should be_nil
  end

  it "should ignore polymorphic relations" do
    relation = create_relation("parrot", "pirate", { :polymorphic => true })
    lambda {
      @parrots_table.create_relation(relation)
    }.should_not change(@parrots_table.relations, :size)
  end

  it "should not generate an error if a primary key name is returned as a symbol" do
    relation = mock("parrot_relation")
    relation.stub!(:name).and_return(:pirate)
    relation.stub!(:class_name).and_return("Pirate")
    relation.stub!(:primary_key_name).and_return(:pirate_id)
    relation.stub!(:options).and_return({})

    # relation = create_relation("parrot", "pirate", :primary_key_name => :pirate_id)
    # relation.stub!(:primary_key_name).and_return(:pirate_id)
    lambda {
      @parrots_table.create_relation(relation)
    }.should_not raise_error
  end

  it "should not generate an error if a table is not instantiated as a model" do
    # TODO: this should test gather_relations as well as set_primary_key
    pending "FIXME: stubbing columns again seems to cancel out existing stubs of it" do
      table_name = "blubs"
      # ActiveRecord::Base.connection.stub!(:columns).with(table_name).and_return([])
      lambda {
        @uninstantiated_table = SchemaTable.new(table_name)
      }.should_not raise_error
    end
  end

  it "should not generate an error if the column inferred from an index does not exist" do
    lambda {
      SchemaTable.new("parrots")
    }.should_not raise_error
  end

  def stub_table(table_name, instantiate = true)
    @relations[table_name] ||= []
    return unless instantiate
    eval "class #{table_name.classify};end"
    table_class = table_name.classify.constantize
    table_class.stub!(:reflect_on_all_associations).and_return(@relations[table_name])
    table_class.stub!(:primary_key).and_return("id")
  end

  def stub_tables(tables)
    ActiveRecord::Base.connection.stub!(:tables).and_return(tables + ["schema_info"])
    # return empty array for indexes method by default
    ActiveRecord::Base.connection.stub!(:indexes).and_return([])

    @relations ||= {}

    tables.each do |table|
      stub_table(table)
    end
  end

end
