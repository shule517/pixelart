#!/bin/sh

RAILS_ROOT=`echo $(cd $(dirname $0)/..; pwd)`

echo "redis-server > /log/redis-server.log 2>&1 &"
redis-server > $RAILS_ROOT/log/redis-server.log 2>&1 &

echo "bundle exec sidekiq"
bundle exec sidekiq
