require File.dirname(__FILE__) + '/../../spec_helper'

module SchemaBrowser
  describe SchemaFormatter do
    it "stores the schema" do
      SchemaFormatter.new([:foo]).schema.should == [:foo]
    end

    describe "#to_www_sql_designer_xml" do
      it "returns the same XML that designer would generate if there are no tables" do
        expected_xml = <<EOT
<?xml version="1.0" encoding="utf-8" ?>
<sql>
  <datatypes db="mysql">
    <group label="Numeric" color="rgb(238,238,170)">
      <type label="Integer" length="0" sql="INTEGER" re="INT" quote=""/>
      <type label="Decimal" length="1" sql="DECIMAL" re="DEC" quote=""/>
      <type label="Single precision" length="0" sql="FLOAT" quote=""/>
      <type label="Double precision" length="0" sql="DOUBLE" re="DOUBLE" quote=""/>
    </group>

    <group label="Character" color="rgb(255,200,200)">
      <type label="Char" length="1" sql="CHAR" quote="'"/>
      <type label="Varchar" length="1" sql="VARCHAR" quote="'"/>
      <type label="Text" length="0" sql="MEDIUMTEXT" re="TEXT" quote="'"/>
      <type label="Binary" length="1" sql="BINARY" quote="'"/>
      <type label="Varbinary" length="1" sql="VARBINARY" quote="'"/>
      <type label="BLOB" length="0" sql="BLOB" re="BLOB" quote="'"/>
    </group>

    <group label="Date &amp; Time" color="rgb(200,255,200)">
      <type label="Date" length="0" sql="DATE" quote="'"/>
      <type label="Time" length="0" sql="TIME" quote="'"/>
      <type label="Datetime" length="0" sql="DATETIME" quote="'"/>
      <type label="Year" length="0" sql="YEAR" quote=""/>
      <type label="Timestamp" length="0" sql="TIMESTAMP" quote="'"/>
    </group>

    <group label="Miscellaneous" color="rgb(200,200,255)">
      <type label="ENUM" length="1" sql="ENUM" quote=""/>
      <type label="SET" length="1" sql="SET" quote=""/>
      <type label="Bit" length="0" sql="bit" quote=""/>
    </group>
  </datatypes>
</sql>
EOT
        SchemaFormatter.new(:models => {}).to_www_sql_designer_xml.should == expected_xml
      end

      it "returns the same XML that designer would generate if there are two tables with a relation (without position data)" do
        expected_xml = <<EOT
<?xml version="1.0" encoding="utf-8" ?>
<sql>
  <datatypes db="mysql">
    <group label="Numeric" color="rgb(238,238,170)">
      <type label="Integer" length="0" sql="INTEGER" re="INT" quote=""/>
      <type label="Decimal" length="1" sql="DECIMAL" re="DEC" quote=""/>
      <type label="Single precision" length="0" sql="FLOAT" quote=""/>
      <type label="Double precision" length="0" sql="DOUBLE" re="DOUBLE" quote=""/>
    </group>

    <group label="Character" color="rgb(255,200,200)">
      <type label="Char" length="1" sql="CHAR" quote="'"/>
      <type label="Varchar" length="1" sql="VARCHAR" quote="'"/>
      <type label="Text" length="0" sql="MEDIUMTEXT" re="TEXT" quote="'"/>
      <type label="Binary" length="1" sql="BINARY" quote="'"/>
      <type label="Varbinary" length="1" sql="VARBINARY" quote="'"/>
      <type label="BLOB" length="0" sql="BLOB" re="BLOB" quote="'"/>
    </group>

    <group label="Date &amp; Time" color="rgb(200,255,200)">
      <type label="Date" length="0" sql="DATE" quote="'"/>
      <type label="Time" length="0" sql="TIME" quote="'"/>
      <type label="Datetime" length="0" sql="DATETIME" quote="'"/>
      <type label="Year" length="0" sql="YEAR" quote=""/>
      <type label="Timestamp" length="0" sql="TIMESTAMP" quote="'"/>
    </group>

    <group label="Miscellaneous" color="rgb(200,200,255)">
      <type label="ENUM" length="1" sql="ENUM" quote=""/>
      <type label="SET" length="1" sql="SET" quote=""/>
      <type label="Bit" length="0" sql="bit" quote=""/>
    </group>
  </datatypes>
  <table name="Post">
    <row name="id" null="1" autoincrement="1">
      <datatype>INTEGER</datatype>
      <default>NULL</default></row>
    <row name="user_id" null="1" autoincrement="0">
      <datatype>INTEGER</datatype>
      <default>NULL</default><relation table="User" row="id" />
    </row>
    <key type="PRIMARY" name="">
      <part>id</part>
    </key>
  </table>
  <table name="User">
    <row name="id" null="1" autoincrement="1">
      <datatype>INTEGER</datatype>
      <default>NULL</default></row>
    <key type="PRIMARY" name="">
      <part>id</part>
    </key>
  </table>
</sql>
EOT
        schema_models = {
          :users => {
            :reflections=>{},
            :columns=> [
              {
                :type=>:integer, :sql_type=>"int(11)", :primary=>true, :name=>"id"
              },
              { :type=>:string,
                :sql_type=>"varchar(255)",
                :primary=>false,
                :name=>"login"
              },
              { :type=>:datetime,
                :sql_type=>"datetime",
                :primary=>false,
                :name=>"created_at"},
              { :type=>:datetime,
                :sql_type=>"datetime",
                :primary=>false,
                :name=>"updated_at"
              }
            ],
            :name=>"User"}
        }
        SchemaFormatter.new(:models => schema_models).to_www_sql_designer_xml.should == expected_xml
      end
    end
  end
end
