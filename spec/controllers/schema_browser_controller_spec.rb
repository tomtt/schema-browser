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
<?xml version="1.0" ?><!-- WWWSQLEditor XML export --><sql>     <table id="0" title="czf_smaha" x="36" y="145" >                <row id="0" pk="pk" index="index">                      <title>id</title>                       <default>0</default>                    <type>Integer</type>            </row>          <row id="1" special="32">                       <title>jmeno</title>                    <default></default>                     <type>String</type>             </row>          <row id="2" special="32">                       <title>mail</title>                     <default></default>                     <type>String</type>             </row>  </table>        <table id="1" title="czf_squat" x="450" y="120" >               <row id="0" pk="pk" index="index">                      <title>id</title>                       <default>0</default>                    <type>Integer</type>            </row>          <row id="1" special="128">                      <title>adresa</title>                   <default></default>                     <type>String</type>             </row>          <row id="2">                    <title>food_amount</title>                      <default>0</default>                    <type>Single precision</type>           </row>          <row id="3">                    <title>beer_amount</title>                      <default>0</default>                    <type>Single precision</type>           </row>  </table>        <table id="2" title="obyvatel" x="200" y="300" >                <row id="0" pk="pk" index="index">                      <title>id</title>                       <default>0</default>                    <type>Integer</type>            </row>          <row id="1" fk="fk" index="index">                      <title>id_smaha</title>                 <default>0</default>                    <type>Integer</type>            </row>          <row id="2" fk="fk" index="index">                      <title>id_squat</title>                 <default>0</default>                    <type>Integer</type>            </row>          <row id="3">                    <title>najem</title>                    <default>0</default>                    <type>Single precision</type>           </row>  </table>        <relation>              <table_1>0</table_1>            <row_1>0</row_1>                <table_2>2</table_2>            <row_2>1</row_2>        </relation>     <relation>              <table_1>1</table_1>            <row_1>0</row_1>                <table_2>2</table_2>            <row_2>2</row_2>        </relation></sql>
EOT
    end
  end

end
