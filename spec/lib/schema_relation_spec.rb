require File.dirname(__FILE__) + '/../spec_helper'

describe SchemaRelation do
  before do
    @rel = SchemaRelation.new(:first, :second, :third, :fourth)
  end

  it "should return first argument of new as origin_table_id" do
    @rel.origin_table_id.should == :first
  end

  it "should return second argument of new as origin_row_id" do
    @rel.origin_row_id.should == :second
  end

  it "should return third argument of new as destination_table_id" do
    @rel.destination_table_id.should == :third
  end

  it "should return fourth argument of new as destination_row_id" do
    @rel.destination_row_id.should == :fourth
  end
end
