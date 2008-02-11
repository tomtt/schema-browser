class SchemaBrowser
  @@debug = false
  def self.debug=(value)
    @@debug = value
  end

  class << self
    def schema_to_xml
      connection = ActiveRecord::Base.connection
      tables = connection.tables.sort
      tables.delete("schema_info")

      s = "<?xml version=\"1.0\" ?>\n"
      xml_builder = Builder::XmlMarkup.new(:target => s, :indent => 2)
      xml_builder.sql {
        database_tables_to_xml(xml_builder, connection, tables)
        relations_to_xml(xml_builder, tables)
      }
      s
    end

    def database_tables_to_xml(xml_builder, connection, tables)
      @table_ids = {}
      @column_ids = {}
      tables.each_with_index do |table, i|
        @table_ids[table] = i
        @column_ids[table] = {}
        dump_table(table, i, connection.indexes(table), xml_builder)
      end
    end

    def relations_to_xml(xml_builder, tables)
      debugger if @@debug
      tables.each do |table|
        table.classify.constantize.reflect_on_all_associations(:belongs_to).each do |reflection|
          relation_to_xml(xml_builder, table, reflection)
        end
      end
    end

    def relation_to_xml(xml_builder, table, reflection)
      xml_builder.relation {
        xml_builder.table_1(@table_ids[table])
        fk_column = "#{reflection.name.to_s}_id"
        xml_builder.row_1(@column_ids[table][fk_column])
        referenced_table = reflection.class_name.tableize
        xml_builder.table_2(@table_ids[referenced_table])
        xml_builder.row_2(@column_ids[table]["id"])
      }
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
          attributes["pk"] = "pk" if column_is_primary?(column)
          attributes["fk"] = "fk" if column_is_foreign_key?(column)
          attributes["index"] = "index" if column_is_primary?(column) ||
            has_index_for_column?(table_name, indexes, column)
          # pk and index are not set on the id field in the live database tables
          # because the value of primary for them is nil. Debugger statement is
          # here for testing this behaviour
          # debugger if column.name == "id"
          @column_ids[table_name][column.name] = i
          dump_column(column, i, xml_builder, attributes)
        end
      }
    end

    def column_is_primary?(column)
      column.name == "id" || column.primary
    end

    def column_is_foreign_key?(column)
      column.name =~ /_id$/ && column.type == :integer
    end

    def dump_column(column, index, xml_builder, options = {})
      attributes = { "id" => index }.merge(options)
      xml_builder.row(attributes) {
        xml_builder.title(column.name)
        xml_builder.default(column.default)
        xml_builder.type(column.type.to_s.capitalize)
      }
    end
  end
end
