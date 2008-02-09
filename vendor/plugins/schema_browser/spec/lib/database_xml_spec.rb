require File.dirname(__FILE__) + '/../spec_helper'

describe SchemaBrowser do
  before(:each) do
    @tables = %w{ pirates parrots }
    stub_tables
    stub_columns
  end

  describe "with just empty tables" do
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

    it "should not include the schema_info table" do
      SchemaBrowser.database_tables_to_xml.should_not have_tag("table[title=?]", "schema_info")
    end
  end

  describe "with columns" do
    before(:each) do
      add_mock_column("pirates", "id", :primary => true, :type => :integer)
      add_mock_column("pirates", "name", :type => :string)
      add_mock_index("pirates", "name")
      add_mock_column("pirates", "quote", :type => :text)
      add_mock_column("pirates", "parrot_id", :type => :integer)
      add_mock_column("parrots", "id", :primary => true, :type => :integer)
      add_mock_column("parrots", "name", :default => "parrrot", :type => :string)
    end

    it "should add a row tag to a table tag for a database column" do
      puts SchemaBrowser.database_tables_to_xml
      SchemaBrowser.database_tables_to_xml.should have_tag("table[title=?]", "pirates") do
        with_tag("row")
      end
    end

    it "should assign a unique id to each column" do
      SchemaBrowser.database_tables_to_xml.should have_tag("table[title=?]", "pirates") do
        @stubbed_columns["pirates"].size.times do |i|
          with_tag("row[id=?]", i)
        end
      end
     end

    it "should add the name of the column in a title tag" do
      SchemaBrowser.database_tables_to_xml.should have_tag("table[title=?]", "pirates") do
        @stubbed_columns["pirates"].each do |col|
          with_tag("row") do
            with_tag("title", col.name)
          end
        end
      end
    end

    it "should set the pk attribute if the column is a primary key" do
      SchemaBrowser.database_tables_to_xml.should have_tag("table[title=?]", "pirates") do
        with_tag("row[pk=pk]") do
          with_tag("title", "id")
        end
      end
    end

    it "should not set the pk attribute if the column is not a primary key" do
      doc = Hpricot.XML(SchemaBrowser.database_tables_to_xml)
      name_row = find_row_with_title(doc, "pirates", "name")
      name_row.should_not have_attribute("pk")
    end

    it "should add the default value of the column in a default tag" do
      SchemaBrowser.database_tables_to_xml.should have_tag("table[title=?]", "parrots") do
        with_tag("row") do
          with_tag("default", "parrrot")
        end
      end
    end

    it "should set the index attribute if the column is a primary key" do
      doc = Hpricot.XML(SchemaBrowser.database_tables_to_xml)
      name_row = find_row_with_title(doc, "pirates", "id")
      name_row.should have_attribute("index")
    end

    it "should set the index attribute if the column is indexed" do
      doc = Hpricot.XML(SchemaBrowser.database_tables_to_xml)
      name_row = find_row_with_title(doc, "pirates", "name")
      name_row.should have_attribute("index")
    end

    it "should not set the index attribute if the column is not indexed" do
      doc = Hpricot.XML(SchemaBrowser.database_tables_to_xml)
      name_row = find_row_with_title(doc, "pirates", "quote")
      name_row.should_not have_attribute("index")
    end

    it "should add the type of the column in a type tag with value string if column is a string" do
      SchemaBrowser.database_tables_to_xml.should have_tag("table[title=?]", "pirates") do
        with_tag("row") do
          with_tag("title", "name")
          with_tag("type", "String")
        end
      end
    end

    it "should add the type of the column in a type tag with value integer if column is an integer" do
      SchemaBrowser.database_tables_to_xml.should have_tag("table[title=?]", "pirates") do
        with_tag("row") do
          with_tag("title", "parrot_id")
          with_tag("type", "Integer")
        end
      end
    end

    def find_row_with_title(hpricot_doc, table, title)
      (hpricot_doc/"table[@title=#{table}]"/"row").select { |t| (t/"title").inner_html == title }[0]
    end

    def add_mock_column(table, column, options = {})
      # #<ActiveRecord::ConnectionAdapters::MysqlColumn:0xb726c458
      #    @primary=nil,
      #    @limit=11,
      #    @name="id",
      #    @default=nil,
      #    @null=false,
      #    @scale=nil,
      #    @type=:integer,
      #    @sql_type="int(11)",
      #    @precision=nil>
      @stubbed_columns[table] << mock_column(column, options)
    end

    def add_mock_index(table, column)
      @stubbed_indexes ||= {}
      @stubbed_indexes[table] ||= []
      mock_column = mock("column")
      mock_column.stub!(:name).and_return("index_#{table}_on_#{column}")
      @stubbed_indexes[table] << mock_column
      ActiveRecord::Base.connection.stub!(:indexes).with(table).and_return(@stubbed_indexes[table])
    end

    def mock_column(name, options)
      col = mock("column")
      col.stub!(:name).and_return(name)
      col.stub!(:primary).and_return(options[:primary] ? options[:primary] : nil)
      col.stub!(:default).and_return(options[:default] ? options[:default] : nil)
      col.stub!(:type).and_return(options[:type])
      col
    end
  end

  describe "with relations" do
    it "should generate a relation for each belongs_to model relation"
    it "should add the id of the table containing the foreign key in a table_1 tag"
    it "should add the id of the column containing the foreign key in a row_1 tag"
    it "should add the id of the table referenced by the foreign key in a table_2 tag"
    it "should add the id of the column referenced by the foreign key in a row_2 tag"
  end

  def stub_tables
    # debugger
    ActiveRecord::Base.connection.stub!(:tables).and_return(@tables + ["schema_info"])
    # return empty array for indexes method by default
    ActiveRecord::Base.connection.stub!(:indexes).and_return([])
  end

  def stub_columns
    @stubbed_columns = {}
    @tables.each do |table|
      @stubbed_columns[table] = []
      ActiveRecord::Base.connection.stub!(:columns).with(table).and_return(@stubbed_columns[table])
    end
  end
end
