class TaskUtil

  def self.exec(name, task)
    logger = Logger.new "#{Settings.path.task_logs}/#{name}.log"
    console = Logger.new(STDOUT)
    logger.extend ActiveSupport::Logger.broadcast(console)
    begin
      logger.info "start"
      task.call logger
    rescue => e
      logger.warn e.backtrace.join("\n")
      logger.warn "task failed"
      raise e
    else
      logger.info "end"
    end
  end

end