require './config/boot'
require './config/environment'
require 'open-uri'

last_update = Misc.find_by_name "reddit_last_update"
last_updated = last_update.value
  puts last_update.value
@url = "http://www.reddit.com/r/UpliftingNews/new.json"
@doc = JSON.parse(open(@url).read)
@doc['data']['children'].each_with_index do |data, index|
  @last_feed_time = data['data']['created'] if index == 0
  p = Post.new
  next if data['data']['preview'].nil?
  break if last_updated >= data['data']['created']

  p.remote_image_url = data['data']['preview']['images'][0]['source']['url']
  p.title = data['data']['title']
  p.url = data['data']['url']
  p.created_at = data['data']['created']
  p.post_type = Post::PTYPE[:reddit]
  p.external = true
  p.save
  puts "Asda"

end
last_update.value = @last_feed_time
last_update.save