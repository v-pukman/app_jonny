class AdminMailer < ApplicationMailer
  STARTED = 'started'
  COMPLETED = 'completed'
  FAILED = 'failed'

  def task_report task_status, task_name, details=nil
    @task_name = task_name
    @color = task_status == FAILED ? 'red' : 'green'
    @message = "#{task_status.upcase}!"
    @details = details.is_a?(Array) ? details.join('<br>') : details
    @date = Time.now
    mail subject: "Task #{task_status}"
  end
end
