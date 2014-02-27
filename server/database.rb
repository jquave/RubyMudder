require 'rubygems'
require 'active_record'
require 'yaml'

def init_db
  dbconfig = YAML::load(File.open('db/database.yml'))
  ActiveRecord::Base.establish_connection(dbconfig)
  puts 'SQLite Database intiialized'
end
