require 'rubygems'
require 'clockwork'
load "./app/models/feed_worker.rb"

module Clockwork

	handler do |job|
	  # do something
	end

	every(5.hours, 'reddit feed') { FeedWorker.perform_async() }

end