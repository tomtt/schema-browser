module SchemaBrowser
  module Rails
    class Schema
      def self.generate_from_rails
        models = Introspection::models.map { |rf| SchemaBrowser::Rails::Model.new(rf) }
        model_data = models.inject(Hash.new) { |hash, model| hash.merge model.table => model.to_hash }
        { :models => model_data }
      end
    end
  end
end
