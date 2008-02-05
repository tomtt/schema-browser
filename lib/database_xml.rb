
def do_dump
  # s = StringIO.new
  s = "<?xml version=\"1.0\" ?>\n"
  xm = Builder::XmlMarkup.new(:target => s, :indent => 2)
  xm.sql {
    tables = ActiveRecord::Base.connection.tables.sort
    tables.each_with_index do |table, i|
      dump_table(table, i, xm)
    end
  }
  s
end

def dump_table(table_name, index, xml_builder)
  xml_builder.table("id" => index.to_s,
                    :title => table_name,
                    "x" => "100",
                    "y" => "120") {
    columns = ActiveRecord::Base.connection.columns(table_name)
    columns.each_with_index do |column, i|
      dump_column(column, i, xml_builder)
    end
  }
end

def dump_column(column_name, index, xml_builder)
  xml_builder.row("id" => index) {
    xml_builder.title(column_name)
  }
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
