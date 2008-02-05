require 'database_xml'

namespace :db do
  namespace :schema do
    desc "Dump structure of database to xml format (readable by WWW SQL Designer)"
    task :dump_xml do
      puts do_dump
    end
  end
end
