module SchemaBrowser
  module Rails
    class Reflection
      def initialize(reflection)
        @reflection = reflection
      end

      def to_hash
        assoc_model_properties = nil
        begin
          active_record_primary_key =
            begin
              @reflection.active_record_primary_key
            rescue NoMethodError => e
              @reflection.klass.primary_key
            end

          assoc_model_properties = {
            :active_record_primary_key => active_record_primary_key,
            :primary_key_name => @reflection.primary_key_name,
            :table_name => @reflection.table_name,
            :valid => true
          }
        rescue NameError => e
          assoc_model_properties = {
            :valid => false
          }
        end

        { :name => @reflection.name,
          :macro => @reflection.macro,
          :association_foreign_key => @reflection.association_foreign_key,
          :through_reflection => @reflection.through_reflection && @reflection.through_reflection.name,
          :class_name => @reflection.class_name,
          :model_name => @reflection.active_record.name
        }.merge(assoc_model_properties)
      end
    end
  end
end
