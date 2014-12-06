require 'sinatra/activerecord/rake'
require './app'
require 'resque/tasks'

ActiveRecord::Tasks::DatabaseTasks.db_dir = 'db'

task "resque:setup" do
  ENV['QUEUE'] = '*'
end
