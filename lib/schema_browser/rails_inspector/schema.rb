module SchemaBrowser
  module RailsInspector
    class Schema
      def self.generate_from_rails
        models = Introspection::concrete_models.map { |rf| SchemaBrowser::RailsInspector::Model.new(rf) }
        model_data = models.inject(Hash.new) { |hash, model| hash.merge model.table => model.to_hash }
        { :models => model_data }
      end
    end
  end
end
