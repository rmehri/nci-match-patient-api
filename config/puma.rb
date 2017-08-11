port 10240, '0.0.0.0'
threads 8,16
workers 3
tag 'patient api'
worker_timeout 120 # for slow startup time
preload_app!
