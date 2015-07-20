require './config/boot'
require './config/environment'
require 'open-uri'
require 'nokogiri'

feeds = {
  'reddit-feed' => "http://www.reddit.com/r/UpliftingNews/new.json",
  'reddit-happy' => "http://www.reddit.com/r/happy/new.json",
  'goodnews-uplift' => 'http://www.goodnewsnetwork.org/category/gnn-uplift,uplift-good-ideas,uplift-good-laugh,uplift-heroes,uplift-inspiring,uplift-kids,uplift-pets,uplift-top-videos/feed/',
}

feeds.each do |feed, link|
  #last_update = Misc.find_by_name "reddit_last_update"
  #last_updated = last_update.value
  @url = link

  case feed
  when /reddit/i
    @doc = JSON.parse(open(@url).read)
    @doc['data']['children'].each_with_index do |data, index|
      begin
        p = Post.new
        next if data['data']['ups'] < 5
        break if not Post.where(title: data['data']['title']).empty?

        p.external_image_url = data['data']['preview']['images'][0]['source']['url'] if not data['data']['preview'].nil?
        p.title = data['data']['title']
        p.url = data['data']['url']
        p.created_at = Time.zone.at data['data']['created_utc']
        p.post_type = Post::PTYPE[:external]
        p.external_author = data['data']['author']
        p.external_author_url = "http://www.reddit.com/user/#{data['data']['author']}"
        p.external = true
        p.save
        puts p.id
        puts "feed"
      rescue StandardError => e
        puts "An error occured #{feed} #{p.title} #{e.message}" 
      end 

    end
  when /goodnews/i
    @doc = Nokogiri::XML(open(@url).read)
    @doc.css('item').each_with_index do |data, index|
      begin
        p = Post.new
        #next if data['data']['ups'] < 5
        break if not Post.where(title: data.css('title').text).empty?

        #p.external_image_url = data['data']['preview']['images'][0]['source']['url'] if not data['data']['preview'].nil?
        p.title = data.css('title').text
        p.url = data.css('link').text
        p.created_at = Time.zone.parse data.css('pubDate').text
        p.post_type = Post::PTYPE[:external]
        p.external_author = data.at_xpath('//dc:creator').text
        #p.external_author_url = "http://www.reddit.com/user/#{data['data']['author']}"
        p.description = data.css('description').text
        p.external = true
        p.save
        puts p.id
        puts "feed"
      rescue StandardError => e
        puts "An error occured #{feed} #{p.title} #{e.message}" 
      end 

    end

  end #end switch
end