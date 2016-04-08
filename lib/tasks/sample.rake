namespace :sample do
  desc "サンプルメッセージを出力"
  task :message => :environment do 
    puts "sample message"
  end

  desc "サンプルログを出力"
  task :log => :environment do 
    logger = Logger.new 'log/sample_log.log'
    logger.info "sample_log: info"
    logger.warn "sample_log: warn"
  end

end
