module SchemaBrowser
  module RailsInspector
    def self.generate_schema
      models = Introspection::concrete_models.map do |rf|
        SchemaBrowser::RailsInspector::Model.new(rf)
      end
      table_data = models.inject(Hash.new) do |hash, model|
        hash.merge model.table => model.to_hash
      end
      SchemaBrowser::Schema.generate_from_table_data(table_data)
    end
  end
end
