module SchemaBrowser
  class SchemaFormatter
    attr_accessor :schema

    def initialize(schema)
      @schema = schema
    end

    def to_www_sql_designer_xml
    end
  end
end
