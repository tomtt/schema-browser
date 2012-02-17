module SchemaBrowser
  class Schema
    attr_reader :tables

    def table_names
      @tables.map(&:name)
    end

    # def table_data_by_name(table_name)
    #   @table_data[table_name.to_sym]
    # end

    def columns_referenced_as_foreign_key_in_table(table)
      compute_referenced_columns!
      return [] unless @referenced_columns[table.name]
      @referenced_columns[table.name].map do |column_name|
        table.column_by_name(column_name)
      end.compact
    end

    def table_by_name(name)
      return @table_by_name[name] if @table_by_name.has_key?(name)
      @table_by_name[name] = tables.select { |t| t.name == name }.first
    end

    def self.generate_from_table_data(table_data)
      tables = table_data.values.inject([]) do |tables, table|
        tables << Table.generate_from_model_data(table)
      end
      new(tables)
    end

    private

    def compute_referenced_columns!
      return if @referenced_columns
      @referenced_columns = {}
      tables.each do |table|
        table.belongs_to_reflections.each do |reflection|
          next if reflection.table_name.blank? # Is this wrong?
          @referenced_columns[reflection.table_name] ||= Set.new
          @referenced_columns[reflection.table_name] << reflection.foreign_key_name
        end
      end
    end

    def initialize(tables)
      @tables = tables
      @table_name_map = {}
    end
  end
end
