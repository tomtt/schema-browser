require File.dirname(__FILE__) + '/../../spec_helper'

module SchemaBrowser
  describe SchemaFormatter do
    it "stores the schema" do
      SchemaFormatter.new([:foo]).schema.should == [:foo]
    end
  end
end
