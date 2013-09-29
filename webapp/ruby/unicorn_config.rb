worker_processes 50 # CPUの数 * 2 ぐらい？
# unicornはノンブロッキングじゃないのでI/Oが詰まるような状況においてはCPUのコア数より増やしたほうが効率が良い.
# メモリが許す限り増やす。どこかで頭打ちにはなると思うが

listen "0.0.0.0:5000", tcp_nopush: true, tcp_defer_accept: 1 # 安全というかデフォ
# listen "0.0.0.0:5000", tcp_nopush: true, tcp_defer_accept: 1, tcp_no_delay: true # アプリの実装を気を付ける必要あり

# See http://unicorn.bogomips.org/Unicorn/Configurator.html#method-i-listen
# :backlog => number of clients: default 1024. this is the backlog of listen() sys call
# :rcvbuf => bytes, :sndbuf => bytes: Linux 2.4+ have intelligent auto-tuning mechanisms and there is no need to specify them
# :tcp_no_delay => true or false: write時にos/kernelレベルでbufferingしてたまってからsendするのをやめて即座にsendします.
#   小さいパケットはまとめて、それからwriteするようにしましょう. 
#   cf. kazeburo yapc 2013 http://www.slideshare.net/kazeburo/yapc2013psgi-plack
# :tcp_nopush => true or false: default false. true にすべき(あれ、今はデフォルトtrueじゃなかったけ？)
#   cf. kazeburo G-WAN はなぜ速いのか http://blog.nomadscafe.jp/2013/09/benchmark-g-wan-and-nginx.html
# :tries => seconds: Times to retry binding a socket if it is already in use. Default 5 seconds.
# :delays => seconds: Seconds to wait between successive tries. Default: 0.5 seconds
# :tcp_defer_accept => integer: Default 1. 
#   コネクションが完了したタイミングではなくデータが到着した段階でプロセスを起こします.
#   プリフォーク型のhttpdにおいて処理中となるプロセス数を減らすテクニック
#   cf.kazeburo yapc 2013http://www.slideshare.net/kazeburo/yapc2013psgi-plack

# timeout 6000 # default: 60
# timeout されるとエラーになって得点出なさそうなので大きく？ => でも、大きくしたら fail するな ...
# でもパフォーマンス出てないってことだからいずれにせよダメですね

preload_app true # allow copy-on-write-friendly GC to save memory
GC.respond_to?(:copy_on_write_friendly=) and GC.copy_on_write_friendly = true

# Below is for ActiveRecord
=begin
before_fork do |server, worker|
  defined?(ActiveRecord::Base) and ActiveRecord::Base.connection.disconnect!
  old_pid = "#{server.config[:pid]}.oldbin"
  if old_pid != server.pid
    begin
      sig = (worker.nr + 1) >= server.worker_processes ? :QUIT : :TTOU
      Process.kill(sig, File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
    end
  end
  sleep 1
end
=end

after_fork do |server, worker|
  #defined?(ActiveRecord::Base) and ActiveRecord::Base.establish_connection
  GC.disable
end
