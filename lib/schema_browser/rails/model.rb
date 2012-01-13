module SchemaBrowser
  module Rails
    class Model
      def initialize(model)
        @model = model
      end

      def columns
        @model.columns.map { |column| SchemaBrowser::Rails::Column.new(column).to_hash }
      end

      def reflections
        @model.reflections.inject({}) do |hash, (name, reflection)|
          hash.merge name => SchemaBrowser::Rails::Reflection.new(reflection).to_hash
        end
      end

      def table
        @model.table_name.to_sym
      end

      def name
        @model.name
      end

      def to_hash
        { :name => name,
          :columns => columns,
          :reflections => reflections
        }
      end
    end
  end
end
