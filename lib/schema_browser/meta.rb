module SchemaBrowser
  module Meta
    def self.sha1_of_git_head
      command = "git --git-dir=%s rev-parse HEAD" % gem_root.join(".git")
      `#{command}`
    end

    def self.reload!
      ruby_source_files.each do |ruby_file|
        load ruby_file
      end
    end

    def self.gem_root
      Pathname.new(__FILE__).dirname.parent.parent
    end

    def self.ruby_source_files
      Dir.glob(gem_root.join("lib", "schema_browser", "**/*.rb"))
    end
  end
end
