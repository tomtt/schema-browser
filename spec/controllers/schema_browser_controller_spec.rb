require File.dirname(__FILE__) + '/../spec_helper'

describe SchemaBrowserController do

  #Delete this example and add some real ones
  it "should use SchemaBrowserController" do
    controller.should be_an_instance_of(SchemaBrowserController)
  end

  describe "to match returned string from original site" do
    it "should return the full string" do
      get :schema
      response.body.should  == <<EOT
<?xml version="1.0" ?><!-- WWWSQLEditor XML export --><sql>     <table id="0" title="users" x="100" y="120" >           <row id="0">                    <title>id</title>                       <default></default>                     <type>Integer</type>            </row>          <row id="1" index="index" special="">                   <title>login</title>                    <default></default>                     <type>String</type>             </row>          <row id="2" special="">                 <title>email</title>                    <default></default>                     <type>String</type>             </row>          <row id="3" special="">                 <title>crypted_password</title>                 <default></default>                     <type>String</type>             </row>          <row id="4" special="">                 <title>salt</title>                     <default></default>                     <type>String</type>             </row>          <row id="5">                    <title>created_at</title>                       <default></default>                     <type>Datetime</type>           </row>          <row id="6">                    <title>updated_at</title>                       <default></default>                     <type>Datetime</type>           </row>          <row id="7" special="">                 <title>remember_token</title>                   <default></default>                     <type>String</type>             </row>          <row id="8">                    <title>remember_token_expires_at</title>                        <default></default>                     <type>Datetime</type>           </row>  </table></sql>
EOT
    end
  end

end
