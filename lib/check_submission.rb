require './lib/timus_api'
require './models/task'
require './models/submission'

class CheckSubmission 
  @queue = :submissions

  def self.perform(submission_id)
    submission = Submission.find(submission_id)
    task = submission.task
    sub_number = TimusApi.send_task(task.task_id, submission.code, submission.lang)
    res = nil
    times = 0
    while (!res && times < 60)
      res = TimusApi.check_task(sub_number)
      res = nil if (res.match(/compiling/i) || res.match(/testing/i) || res.match(/running/i) || res.match(/waiting/i))
      sleep 1
      times += 1
    end
    if (res)
      submission.result = res
      submission.save
    end
  end
end
