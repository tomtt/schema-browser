class SchemaBrowserController < ApplicationController
  layout "schema_browser"

  def schema
    schema_data = SchemaBrowser::RailsInspector.generate_schema
    respond_to do |format|
      format.xml { render :xml => SchemaBrowser::SchemaFormatter.new(schema_data).to_www_sql_designer_xml }
      format.json { render :json => schema_data.to_json }
    end
  end
end
