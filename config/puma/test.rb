# config/puma/production.rb
environment "test"

# UNIX Socketへのバインド
tmp_path = "#{File.expand_path("../../..", __FILE__)}/tmp"
bind "unix://#{tmp_path}/sockets/group-manager-test-puma.sock"

# スレッド数とWorker数の指定
threads 3, 3
workers 2
preload_app!

# デーモン化の設定
daemonize true
pidfile "#{tmp_path}/pids/group-manager-test-puma.pid"
stdout_redirect "#{tmp_path}/logs/group-manager-test-puma.stdout.log", "#{tmp_path}/logs/group-manager-test-puma.stderr.log", true

# Allow puma to be restarted by `rails restart` command.
plugin :tmp_restart

# puma_worker_killerの設定
before_fork do
  require 'puma_worker_killer'
  PumaWorkerKiller.config do |config|
    # 閾値を超えた場合にkillする
    config.ram           = 1024 # mb
    config.frequency     = 5 * 60 # per 5minute
    config.percent_usage = 0.9 # 90%
    # 閾値を超えたかどうかに関わらず定期的にkillする
    config.rolling_restart_frequency = 24 * 3600 # per 1day
    # workerをkillしたことをログに残す
    config.reaper_status_logs = true
  end
  PumaWorkerKiller.start
  ActiveRecord::Base.connection_pool.disconnect! if defined?(ActiveRecord)
end

on_worker_boot do
  ActiveRecord::Base.establish_connection if defined?(ActiveRecord)
end

