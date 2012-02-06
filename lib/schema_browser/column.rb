module SchemaBrowser
  class Column
    attr_accessor :type, :primary, :name, :sql_type

    def self.generate_from_model_data(model_data)
      column = new
      column.type = model_data[:type]
      column.primary = model_data[:primary]
      column.name = model_data[:name]
      column.sql_type = model_data[:sql_type]
      column
    end
  end
end
