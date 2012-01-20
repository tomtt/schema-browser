module SchemaBrowser
  module RailsInspector
    class Column
      def initialize(column)
        @column = column
      end

      def to_hash
        { :name => @column.name,
          :sql_type => @column.sql_type,
          :primary => @column.primary,
          :type => @column.type
        }
      end
    end
  end
end
