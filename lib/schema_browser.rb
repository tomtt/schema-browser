$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

module SchemaBrowser
  def self.reload
    Dir.glob(File.join(File.dirname(__FILE__), "**", "*.rb")).each do |rb_file|
      load rb_file
    end
  end
end
