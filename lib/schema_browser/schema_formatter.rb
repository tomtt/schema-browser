module SchemaBrowser
  class SchemaFormatter
    attr_accessor :schema

    def initialize(schema)
      @schema = schema
    end

    def to_www_sql_designer_xml
      @@last_x = 0
      @@last_y = 0

      xml = <<"EOT"
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
#{xml_for_tables}</sql>
EOT
    end

    private

    def xml_for_tables
      @schema.models.map do |model|
        foreign_key_columns = @schema.columns_referenced_as_foreign_key_in_model(model)
        relational_columns = Set.new(foreign_key_columns + @model.belongs_to_columns)
        xml_for_model(model.table_name, relational_columns)
        # @schema[:models].map { |table, attributes| xml_for_model(table, attributes) }.join("\n") +
        #   (1..50).map { |i| xml_for_model(nil, :name => "Dummy #{i}") }.join("\n")
      end
    end

    def new_offset
      val = [@@last_x, @@last_y]
      @@last_x += 120
      if(@@last_x > 1100)
        @@last_y += 40
        @@last_x = @@last_y / 2
      end
      val
    end

    def xml_for_model(table_name, columns)
      (x_offset, y_offset) = new_offset
      xml = <<EOT
  <table x="#{x_offset}" y="#{y_offset}" name="#{attributes[:name].camelize}">
    <row name="id" null="1" autoincrement="1">
      <datatype>INTEGER</datatype>
      <default>NULL</default></row>
    <key type="PRIMARY" name="">
      <part>id</part>
    </key>
  </table>
EOT
      xml
    end
  end
end
