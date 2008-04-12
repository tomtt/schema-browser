class SchemaBrowserGenerator < Rails::Generator::Base
  def manifest
    record do |m|
      images = ["back.gif",
                "bar_bottom.png",
                "bar_corner.png",
                "bar_left.png",
                "table_bottom.png",
                "table_corner.png",
                "table_right.png",
                "throbber.gif"]
      m.directory('public/images/schema_browser')
      images.each do |img|
        m.file "public/images/#{img}",  "public/images/schema_browser/#{img}"
      end

      javascripts = ["config",
                     "oz",
                     "wwwsqldesigner"]

      m.directory('public/javascripts/schema_browser')
      javascripts.each do |js|
        m.file "public/javascripts/#{js}.js", "public/javascripts/schema_browser/#{js}.js"
      end

      stylesheets = ["doc",
                     "ie6",
                     "ie7",
                     "print",
                     "style"]

      m.directory('public/stylesheets/schema_browser')
      stylesheets.each do |css|
        m.file "public/stylesheets/#{css}.css", "public/stylesheets/schema_browser/#{css}.css"
      end

      locales = ["en"]
      m.directory('public/xml/schema_browser/locales')
      locales.each do |locale|
        m.file "public/xml/locales/#{locale}.xml", "public/xml/schema_browser/locales/#{locale}.xml"
      end

      dbs = ["mysql", "sqlite"]
      dbs.each do |db|
        m.directory("public/xml/schema_browser/dbs/#{db}")
        m.file "public/xml/dbs/#{db}/datatypes.xml", "public/xml/schema_browser/dbs/#{db}/datatypes.xml"
        m.file "public/xml/dbs/#{db}/output.xsl", "public/xml/schema_browser/dbs/#{db}/output.xsl"
      end
      
      m.directory('app/controllers')
      m.file "app/controllers/schema_browser_controller.rb", "app/controllers/schema_browser_controller.rb"
      m.directory('app/views/schema_browser')
      m.file "app/views/schema_browser/index.html.erb", "app/views/schema_browser/index.html.erb"
      m.file "app/views/schema_browser/schema.xml.builder", "app/views/schema_browser/schema.xml.builder"
      m.directory('app/views/layouts')
      m.file "app/views/layouts/schema_browser.html.erb", "app/views/layouts/schema_browser.html.erb"
    end
  end
end
