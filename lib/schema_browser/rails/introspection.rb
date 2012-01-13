module SchemaBrowser
  module Rails
    class Introspection
      def self.concrete_models
        models.select { |m| !m.abstract_class }
      end

      def self.models
        ensure_model_files_are_loaded!
        ActiveRecord::Base.send(:subclasses)
      end

      private

      def self.ensure_model_files_are_loaded!
        Dir.glob(::Rails.root + "app/models/**/*.rb").sort.each { |file| require file }
      end
    end
  end
end
