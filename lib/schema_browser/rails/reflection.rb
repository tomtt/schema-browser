module SchemaBrowser
  module Rails
    class Reflection
      def initialize(reflection)
        @reflection = reflection
      end

      def to_hash
        attributes =
        { :name => @reflection.name,
          :macro => @reflection.macro,
          :class_name =>@reflection.class_name,
          :active_record_primary_key => @reflection.active_record_primary_key,
          :association_foreign_key => @reflection.association_foreign_key,
          :association_primary_key =>@reflection.association_primary_key,
          :primary_key_name => @reflection.primary_key_name,
          :table_name => @reflection.table_name,
          :through_reflection => @reflection.through_reflection && @reflection.through_reflection.name
        }
      end
    end
  end
end
