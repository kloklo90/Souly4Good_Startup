require './config/boot'
require './config/environment'
require 'open-uri'

last_update = Misc.find_by_name "reddit_last_update"
last_updated = last_update.value
  puts last_update.value
@url = "http://www.reddit.com/r/UpliftingNews/new.json"
@doc = JSON.parse(open(@url).read)
@doc['data']['children'].each_with_index do |data, index|
  begin
    @last_feed_time = data['data']['created'] if index == 0
    p = Post.new
    next if data['data']['preview'].nil?
    break if last_updated >= data['data']['created']

    p.external_image_url = data['data']['preview']['images'][0]['source']['url']
    p.title = data['data']['title']
    p.url = data['data']['url']
    p.created_at = Time.zone.at data['data']['created_utc']
    p.post_type = Post::PTYPE[:external]
    p.external_author = data['data']['author']
    p.external_author_url = "http://www.reddit.com/user/#{data['data']['author']}"
    p.external = true
    p.save
    puts "feed"
  rescue  
    puts 'An error occured'  
  end 

end
last_update.value = @last_feed_time
last_update.save