require File.dirname(__FILE__) + '/../spec_helper'
require 'database_xml'
require 'rake'
load '/usr/local/lib/ruby/gems/1.8/gems/rails-2.0.2/lib/tasks/misc.rake'
load '/usr/local/lib/ruby/gems/1.8/gems/rails-2.0.2/lib/tasks/databases.rake'

describe "database xml dump" do
  before(:each) do
    load_schema_file_into_test_database(File.join(RAILS_ROOT, %w{ spec fixtures schema.rb}))
  end

  it "should put the tables in the test schema in the xml" do
    ActiveRecord::Base.connection.stub!(:columns).and_return([])
    do_dump.should == <<EOT
<?xml version="1.0" ?>
<sql>
  <table x="100" y="120" id="0" title="comments">
  </table>
  <table x="100" y="120" id="1" title="posts">
  </table>
  <table x="100" y="120" id="2" title="users">
  </table>
</sql>
EOT
  end

  it "should put the tables in the xml" do
    ActiveRecord::Base.connection.stub!(:tables).and_return(%w{ apes notes mees })
    ActiveRecord::Base.connection.stub!(:columns).and_return([])
    do_dump.should == <<EOT
<?xml version="1.0" ?>
<sql>
  <table x="100" y="120" id="0" title="apes">
  </table>
  <table x="100" y="120" id="1" title="mees">
  </table>
  <table x="100" y="120" id="2" title="notes">
  </table>
</sql>
EOT
  end

  def load_schema_file_into_test_database(filename)
    previous_schema_file = ENV['SCHEMA']
    ENV['SCHEMA'] = filename
    restore_original_schema(previous_schema_file)
    Rake::Task["db:test:clone"].invoke
  end

  def restore_original_schema(original_value)
    if original_value
      ENV['SCHEMA'] = original_value
    else
      ENV.delete('SCHEMA')
    end
  end
end
