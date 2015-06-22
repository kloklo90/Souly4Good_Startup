worker: bundle exec sidekiq -r ./app/model/feed_worker.rb -c 5
web: bundle exec rails s -p ${PORT:-3000} -e ${RACK_ENV:-production}