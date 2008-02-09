class SchemaBrowserController < ApplicationController
  layout "schema_browser", :except => :schema

  def schema
    respond_to do |format|
      format.xml {
        # render :xml => SchemaBrowser.database_tables_to_xml.gsub("\n", "").squeeze
        render :xml => SchemaBrowser.database_tables_to_xml.gsub(Regexp.new("\\n\\s*"), "")
      }
    end
  end
end
