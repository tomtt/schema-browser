module SchemaBrowser
  module Rails
    class Introspection
      def self.models
        ensure_model_files_are_loaded!
        ActiveRecord::Base.send(:subclasses)
      end

      private

      def self.ensure_model_files_are_loaded!
        Dir.glob(::Rails.root + "app/models/**/*.rb").each { |file| require file }
      end
    end
  end
end
