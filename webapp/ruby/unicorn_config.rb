@dir = "/home/game/gitrepos/isucon2/webapp/ruby/"
working_directory @dir

listen "#{@dir}tmp/sockets/unicorn.sock", backlog: 1024
pid "#{@dir}tmp/pids/unicorn.pid"
stderr_path "#{@dir}log/unicorn.stderr.log"
stdout_path "#{@dir}log/unicorn.stdout.log"

worker_processes 50 # CPUの数 * 2 ぐらい？
timeout 60 # default: 60

preload_app true # allow copy-on-write-friendly GC to save memory
GC.respond_to?(:copy_on_write_friendly=) and GC.copy_on_write_friendly = true

after_fork do |server, worker|
  GC.disable
end
