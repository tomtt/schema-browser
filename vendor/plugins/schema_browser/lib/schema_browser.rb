require 'schema_table'
require 'schema_column'
require 'schema_relation'

class SchemaBrowser
  attr_reader :tables, :relations

  def initialize
    @tables = SchemaBrowser.get_tables_from_connection.map { |table_name| SchemaTable.new(table_name) }
    @tables.each do |table|
      table.gather_relations
    end
  end

  def relations
    unless @relations
      @relations = []
      @tables.each do |table|
        @relations += table.relations
      end
    end
    @relations
  end

  protected

  def self.get_tables_from_connection
    tables = ActiveRecord::Base.connection.tables
    tables.delete("schema_info")
    tables.sort
  end
end
