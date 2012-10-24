require 'rails/generators'

class SchemaBrowserGenerator < Rails::Generators::Base
  def self.source_root
    @source_root ||= File.join(File.dirname(__FILE__), 'templates')
  end

  def generate_schema_browser
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
    directory_name = "vendor/assets/images/schema_browser"
    Dir.mkdir(directory_name) unless File.exists?(directory_name)

    images.each do |img|
      copy_file "assets/images/#{img}",  "vendor/assets/images/schema_browser/#{img}"
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

    directory_name = "vendor/assets/javascripts/schema_browser"
    Dir.mkdir(directory_name) unless File.exists?(directory_name)

    javascripts.each do |js|
      copy_file "assets/javascripts/#{js}", "vendor/assets/javascripts/schema_browser/#{js}"
    end

    stylesheets = ["bar.css",
                   "foo",
                   "style.css"]

    directory_name = "vendor/assets/stylesheets/schema_browser"
    Dir.mkdir(directory_name) unless File.exists?(directory_name)

    stylesheets.each do |css|
      copy_file "assets/stylesheets/#{css}", "vendor/assets/stylesheets/schema_browser/#{css}"
    end

    directory_name = "app/controllers"
    Dir.mkdir(directory_name) unless File.exists?(directory_name)
    copy_file "app/controllers/schema_browser_controller.rb", "app/controllers/schema_browser_controller.rb"

    directory_name = "app/views/schema_browser"
    Dir.mkdir(directory_name) unless File.exists?(directory_name)
    copy_file "app/views/schema_browser/index.html.erb", "app/views/schema_browser/index.html.erb"
    copy_file "app/views/schema_browser/schema.xml.builder", "app/views/schema_browser/schema.xml.builder"

    directory_name = "app/views/layouts"
    Dir.mkdir(directory_name) unless File.exists?(directory_name)
    copy_file "app/views/layouts/schema_browser.html.erb", "app/views/layouts/schema_browser.html.erb"

  end
end
