clock: bundle exec clockwork clock.rb
worker: bundle exec sidekiq -r ./app/model/feed_worker.rb -c 5