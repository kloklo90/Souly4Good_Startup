require 'rubygems'
require 'clockwork'
require './config/boot'
require './config/environment'

include Clockwork

handler do |job|
  # do something
end

every(5.hours, 'job_name')