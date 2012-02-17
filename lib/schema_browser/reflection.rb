module SchemaBrowser
  class Reflection
    attr_accessor :data

    def macro
      data[:macro]
    end

    def foreign_key_name
      data[:active_record_primary_key]
    end

    def column_name
      data[:primary_key_name]
    end

    def is_macro?(macro)
      data[:macro].to_s == macro.to_s
    end

    def table_name
      data[:table_name]
    end

    def self.generate_from_model_data(model_data)
      reflection = new
      reflection.data = model_data
      reflection
    end
  end
end
