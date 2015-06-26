worker: bundle exec sidekiq -r ./app/models/feed_worker.rb -c 5
web: bundle exec rails s -p ${PORT:-3000} -e ${RACK_ENV:-production}
clock: bundle exec clockwork clock.rb 