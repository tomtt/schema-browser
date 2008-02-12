require File.dirname(__FILE__) + '/../spec_helper'

describe SchemaColumn do
  before do
    ar_column = mock_column("pirate_id", :integer, nil)
    @column = SchemaColumn.new(ar_column)
  end

  def mock_column(name, type, default)
    column = mock("active record column")
    column.stub!(:name).and_return(name)
    column.stub!(:type).and_return(type)
    column.stub!(:default).and_return(default)
    column
  end

  it "should return the active record column's name as its title" do
    @column.title.should == "pirate_id"
  end

  it "should return 'Integer' as it's type if the active record column's type is :integer" do
    @column.type.should == "Integer"
  end

  it "should return 'String' as it's type if the active record column's type is :string" do
    ar_column = mock_column("name", :string, "")
    column = SchemaColumn.new(ar_column)
    column.type.should == "String"
  end

  it "should return 'Datetime' as it's type if the active record column's type is :datetime" do
    ar_column = mock_column("lost_leg_at", :datetime, nil)
    column = SchemaColumn.new(ar_column)
    column.type.should == "Datetime"
  end

  it "should set the id in the attributes to a string of its column_id" do
    @column.attributes["id"].should == @column.column_id.to_s
  end

  it "should include 'pk' => 'pk' in the attributes if it is set as a primary key" do
    @column.primary_key = true
    @column.attributes["pk"].should == "pk"
  end

  it "should not include 'pk' in the attributes if it is not set as a primary key" do
    @column.attributes.should_not have_key("pk")
  end

  it "should include 'fk' => 'fk' in the attributes if it is set as a foreign key" do
    @column.foreign_key = true
    @column.attributes["fk"].should == "fk"
  end

  it "should not include 'fk' in the attributes if it is not set as a foreign key" do
    @column.attributes.should_not have_key("fk")
  end

  it "should include 'index' => 'index' in the attributes if it is set to have an index" do
    @column.index = true
    @column.attributes["index"].should == "index"
  end

  it "should not include 'index' in the attributes if it is not set to have an index" do
    @column.attributes.should_not have_key("index")
  end

  it "should assign a unique column_id to each new instance" do
    ar_column = mock_column("pirate_id", :integer, nil)
    col1 = SchemaColumn.new(ar_column)
    col2 = SchemaColumn.new(ar_column)
    col1.column_id.should_not == col2.column_id
  end
end
