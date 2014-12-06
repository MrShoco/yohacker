class Task < ActiveRecord::Base
  has_many :task_samples
  has_many :task_tags
  has_many :submissions
end
