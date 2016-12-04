class TaskMailer < ApplicationMailer
  STARTED = 'started'
  COMPLETED = 'completed'
  FAILED = 'failed'

  def status_report task_status, task_name, details=nil
    @task_name = task_name
    @color = task_status == FAILED ? 'red' : 'green'
    @message = "#{task_status.upcase}!"
    @details = details.is_a?(Array) ? details.join('<br>') : details
    @time = Baidu::Helper::DateTime.curr_time
    mail subject: "Task #{task_status}"
  end

end
