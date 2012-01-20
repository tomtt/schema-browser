module SchemaBrowser
  module RailsInspector
    class Model
      def initialize(model)
        @model = model
      end

      def columns
        @model.columns.map { |column| SchemaBrowser::RailsInspector::Column.new(column).to_hash }
      end

      def reflections(macros = [:belongs_to, :has_many, :has_one, :has_and_belongs_to_many])
        @model.reflections.inject({}) do |hash, (name, reflection)|
          if macros.include?(reflection.macro)
            hash.merge name => SchemaBrowser::RailsInspector::Reflection.new(reflection).to_hash
          else
            hash
          end
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
