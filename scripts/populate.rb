require './lib/connection'

require './models/user'
require './models/task'
require './models/task_sample'
require './models/task_tag'

require './lib/timus_api'

Connection.connect_db(ENV['RACK_ENV'])

start = Time.now

res = TimusApi.get_tasks

Task.delete_all
TaskSample.delete_all
TaskTag.delete_all

res.each do |task|
  task[:task_id] = task[:id]
  tags = task[:tags]
  samples = task[:sample]
  task.delete :id
  task.delete :tags
  task.delete :sample
  task = Task.create(task)
  tags.each do |tag|
    task.task_tags.create(:title_eng => tag[:eng], :title_rus => tag[:rus])
  end
  samples.each do |sample|
    task.task_samples.create(sample)
  end
end

puts "Tasks count: #{Task.count}"
puts "Time: #{Time.now - start}"
