# monkey patch xml builder to allow a type tag
# module Builder
#   class XmlBase
#     # Override Object.type to allow type tags
#     def type(*args, &block)
#       method_missing(:type, args, block)
#     end
#   end
# end

class SchemaBrowser
  class << self
    def database_tables_to_xml
      conn = ActiveRecord::Base.connection
      s = "<?xml version=\"1.0\" ?>\n"
      xm = Builder::XmlMarkup.new(:target => s, :indent => 2)
      xm.sql {
        tables = conn.tables.sort
        tables.each_with_index do |table, i|
          dump_table(table, i, conn.indexes(table), xm)
        end
      }
      s
    end

    def has_index_for_column?(table_name, indexes, column)
      # #<struct ActiveRecord::ConnectionAdapters::IndexDefinition table="users", name="index_users_on_login", unique=false, columns=["login"]>
      indexes.each do |index|
        return true if index.name == "index_#{table_name}_on_#{column.name}"
      end
      false
    end

    def dump_table(table_name, id, indexes, xml_builder)
      xml_builder.table("id" => id.to_s,
                        :title => table_name,
                        "x" => "100",
                        "y" => "120") {
        columns = ActiveRecord::Base.connection.columns(table_name)
        columns.each_with_index do |column, i|
          attributes = {}
          attributes["pk"] = "pk" if column.primary
          attributes["index"] = "index" if column.primary ||
            has_index_for_column?(table_name, indexes, column)
          dump_column(column, i, xml_builder, attributes)
        end
      }
    end

    def dump_column(column, index, xml_builder, options = {})
      attributes = { "id" => index }.merge(options)
      xml_builder.row(attributes) {
        xml_builder.title(column.name)
        xml_builder.default(column.default)
        # At some point the line below has blown up due to type being called on
        # xml_builder. The purpose of the monkey patch at the top of the file
        # is to prevent this, but the error has since stopped occuring.
        xml_builder.type(column.type.to_s)
      }
    end
  end
end

# <?xml version="1.0" ?>
# <!-- WWWSQLEditor XML export -->
# <sql>
#   <table id="0" title="czf_smaha" x="100" y="120" >
#     <row id="0" pk="pk" index="index">
#       <title>id</title>
#       <default>0</default>
#       <type>Integer</type>
#     </row>
#     <row id="1" special="32">
#       <title>jmeno</title>
#       <default></default>
#       <type>String</type>
#     </row>
#     <row id="2" special="32">
#       <title>mail</title>
#       <default></default>
#       <type>String</type>
#     </row>
#   </table>
#   <table id="1" title="czf_squat" x="450" y="120" >
#     <row id="0" pk="pk" index="index">
#       <title>id</title>
#       <default>0</default>
#       <type>Integer</type>
#     </row>
#     <row id="1" special="128">
#       <title>adresa</title>
#       <default></default>
#       <type>String</type>
#     </row>
#     <row id="2">
#       <title>food_amount</title>
#       <default>0</default>
#       <type>Single precision</type>
#     </row>
#     <row id="3">
#       <title>beer_amount</title>
#       <default>0</default>
#       <type>Single precision</type>
#     </row>
#   </table>
#   <table id="2" title="obyvatel" x="273" y="334" >
#     <row id="0" pk="pk" index="index">
#       <title>id</title>
#       <default>0</default>
#       <type>Integer</type>
#     </row>
#     <row id="1" fk="fk" index="index">
#       <title>id_smaha</title>
#       <default>0</default>
#       <type>Integer</type>
#     </row>
#     <row id="2" fk="fk" index="index">
#       <title>id_squat</title>
#       <default>0</default>
#       <type>Integer</type>
#     </row>
#     <row id="3">
#       <title>najem</title>
#       <default>0</default>
#       <type>Single precision</type>
#     </row>
#   </table>
#   <relation>
#     <table_1>0</table_1>
#     <row_1>0</row_1>
#     <table_2>2</table_2>
#     <row_2>1</row_2>
#   </relation>
#   <relation>
#     <table_1>1</table_1>
#     <row_1>0</row_1>
#     <table_2>2</table_2>
#     <row_2>2</row_2>
#   </relation>
# </sql>
