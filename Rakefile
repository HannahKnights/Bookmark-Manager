require 'data_mapper'
require_relative 'app/models/link'
require_relative 'app/models/tag'
require_relative 'app/models/user'

task :auto_upgrade do
  DataMapper.auto_upgrade!
  puts "Auto-upgrade complete (no data loss)"
end

task :auto_migrate do
  DataMapper.auto_migrate!
  puts "Auto-migrate complete (data could have been lost)"
end

task :clear do
  DataMapper.setup(:default, ENV['DATABASE_URL'] || "postgres://localhost/bookmark_manager_#{env}")
  Link.destroy
  User.destroy
  Tag.destroy
end