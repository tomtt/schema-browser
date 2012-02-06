module SchemaBrowser
  class Table
    attr_accessor :name, :model_name, :columns, :reflections

    def belongs_to_reflections
      reflections.select { |r| r.is_macro?(:belongs_to) }
    end

    def belongs_to_columns
      []
    end

    def column_by_name(name)
      columns.select { |c| c.name == name }.first
    end

    def self.generate_from_model_data(model_data)
      table = new
      table.name = model_data[:table_name]
      table.model_name = model_data[:name]
      table.columns = model_data[:columns].map { |c| Column.generate_from_model_data(c) }
      table.reflections = model_data[:reflections].values.map { |r| Reflection.generate_from_model_data(r) }
      table
    end
  end
end
