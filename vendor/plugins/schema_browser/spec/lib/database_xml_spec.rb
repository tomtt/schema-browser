require File.dirname(__FILE__) + '/../spec_helper'

describe SchemaBrowser do
  it "should produce xml for the tables" do
    ActiveRecord::Base.connection.stub!(:tables).and_return(%w{ pirates parrots })
    ActiveRecord::Base.connection.stub!(:columns).and_return([])
    SchemaBrowser.do_dump.should == <<EOT
<?xml version="1.0" ?>
<sql>
  <table x="100" y="120" id="0" title="parrots">
  </table>
  <table x="100" y="120" id="1" title="pirates">
  </table>
</sql>
EOT
  end
end
