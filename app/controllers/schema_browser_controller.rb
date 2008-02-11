class SchemaBrowserController < ApplicationController
  layout "schema_browser", :except => [:schema, :schema_builder]

  def schema
    respond_to do |format|
      format.xml
    end
  end
end
