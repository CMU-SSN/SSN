root = "/home/deployer/apps/SSN/current"
working_directory root
pid "#{root}/tmp/pids/unicorn.pid"
stderr_path "#{root}/log/unicorn.log"
stdout_path "#{root}/log/unicorn.log"

listen 5000, :tcp_nopush => true
worker_processes 2
timeout 30