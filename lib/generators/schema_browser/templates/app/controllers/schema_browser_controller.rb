class SchemaBrowserController < ApplicationController
  layout "schema_browser", :except => [:schema]

  def schema
    respond_to do |format|
      format.xml
    end
  end
end
