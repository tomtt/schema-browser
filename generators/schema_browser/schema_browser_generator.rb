class SchemaBrowserGenerator < Rails::Generator::Base
  def manifest
    record do |m|
      images = ["back.gif",
                "h_1-n.gif",
                "h_n-1.gif",
                "move_cross.gif",
                "shadow_bottom.png",
                "shadow_corner.png",
                "shadow.png",
                "shadow_right.png",
                "v_1-n.gif",
                "v_n-1.gif"]
      m.directory('public/images/schema_browser')
      images.each do |img|
        m.file "public/images/#{img}",  "public/images/schema_browser/#{img}"
      end

      javascripts = ["ajax.js",
                     "animator.js",
                     "generic.js",
                     "io.js",
                     "main.js",
                     "objects.js",
                     "settings.js",
                     "sql_types.js",
                     "style.js"]
      m.directory('public/javascripts/schema_browser')
      javascripts.each do |js|
        m.file "public/javascripts/#{js}", "public/javascripts/schema_browser/#{js}"
      end

      stylesheets = ["bar.css",
                     "foo",
                     "style.css"]
      m.directory('public/stylesheets/schema_browser')
      stylesheets.each do |css|
        m.file "public/stylesheets/#{css}", "public/stylesheets/schema_browser/#{css}"
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
