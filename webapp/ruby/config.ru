require './app'

require 'unicorn/oob_gc'
use Unicorn::OobGC, 10 # run GC each 10 requests

require 'unicorn/worker_killer'
# Max Requests per Worker
use Unicorn::WorkerKiller::MaxRequests, 3072, 4096
# Max Memory size (RSS) per worker
use Unicorn::WorkerKiller::Oom, (192*(1024**2)), (256*(1024**2))

run Isucon2App
