require './config/boot'
require './config/environment'
require 'yaml'

unless File.exists?(Rails.root.join("config/badges.yml"))
  puts "....ERROR DETAIL START ...."
  puts "Please create config file in this directory #{Rails.root.join("config/badges.yml")}"
  puts "....ERROR DETAIL END   ...."
end

begin
  badges = YAML.load_file(Rails.root.join("config/badges.yml")).with_indifferent_access[Rails.env]['badges']
rescue Exception => e
  puts "....ERROR DETAIL START ...."
  p e.inspect
  puts "....ERROR DETAIL END   ...."
  puts "....ERROR DETAIL START ...."
  puts "Configuration file is not okay #{Rails.root.join("config/badges.yml")}"
  puts "....ERROR DETAIL END   ...."
end

badges.each do |badge|
  case badge[:id].to_i
  when 4
    User.where("users.invitations_count >= #{badge[:minimum_limit]}").order("users.invitations_count DESC").limit(badge[:daily_limit]).each do |top_user|
      next if top_user.blank? or top_user.user_badges.where(:badge_id => 4).first.present?
      top_user.user_badges.create(:badge_id => 4)
    end
  when 5
    User.joins("INNER JOIN votes ON users.id = votes.voter_id AND votes.voter_type = 'User' and votes.votable_type = 'Post'").select("users.*, count(users.id) as total_votes").group("users.id").having("total_votes >= #{badge[:minimum_limit]}").order("total_votes DESC").group("users.id").limit(badge[:daily_limit]).each do |top_user|
      next if top_user.blank? or top_user.user_badges.where(:badge_id => 5).first.present?
      top_user.user_badges.create(:badge_id => 5)
    end
  when 6
    User.joins(:posts).joins("INNER JOIN votes ON posts.id = votes.votable_id AND votes.votable_type = 'Post' AND users.id != votes.voter_id and votes.voter_type = 'User'").select("users.*, count(users.id) as total_votes").having("total_votes >= #{badge[:minimum_limit]}").order("total_votes DESC").group("users.id").limit(badge[:daily_limit]).each do |top_user|
      next if top_user.blank? or top_user.user_badges.where(:badge_id => 6).first.present?
      top_user.user_badges.create(:badge_id => 6)
    end
  when 7
    User.joins(:comments).select("users.*, count(users.id) as total_comments").having("total_comments >= #{badge[:minimum_limit]}").order("total_comments DESC").group("users.id").limit(badge[:daily_limit]).each do |top_user|
      next if top_user.blank? or top_user.user_badges.where(:badge_id => 7).first.present?
      top_user.user_badges.create(:badge_id => 7)
    end
  when 8
    #challenge posts
    User.joins(:posts).select("users.*, count(users.id) as total_posts").where({ :posts => { :post_type => Post::PTYPE[:challenge] } }).having("total_posts >= #{badge[:minimum_limit]}").order("total_posts DESC").group("users.id").limit(badge[:daily_limit]).each do |top_user|
      next if top_user.blank? or top_user.user_badges.where(:badge_id => 8).first.present?
      top_user.user_badges.create(:badge_id => 8)
    end
  when 9
    #challenge posts user
    User.joins(:posts).select("users.*, count(users.id) as total_posts").where({ :posts => { :post_type => Post::PTYPE[:user] } }).having("total_posts >= #{badge[:minimum_limit]}").order("total_posts DESC").group("users.id").limit(badge[:daily_limit]).each do |top_user|
      next if top_user.blank? or top_user.user_badges.where(:badge_id => 9).first.present?
      top_user.user_badges.create(:badge_id => 9)
    end
  when 10
    #news posts user
    User.joins(:posts).select("users.*, count(users.id) as total_posts").where({ :posts => { :post_type => Post::PTYPE[:external] } }).having("total_posts >= #{badge[:minimum_limit]}").order("total_posts DESC").group("users.id").limit(badge[:daily_limit]).each do |top_user|
      next if top_user.blank? or top_user.user_badges.where(:badge_id => 10).first.present?
      top_user.user_badges.create(:badge_id => 10)
    end
  when 11
    User.joins("LEFT JOIN comments ON users.id = comments.user_id").joins("LEFT JOIN votes ON users.id = votes.voter_id AND votes.voter_type = 'User' and votes.votable_type = 'Post'").where("comments.id is not null or votes.id is not null").select("users.*, count(users.id) as total_cl").having("total_cl >= #{badge[:minimum_limit]}").order("total_cl DESC").group("users.id").limit(badge[:daily_limit]).each do |top_user|
      next if top_user.blank? or top_user.user_badges.where(:badge_id => 11).first.present?
      top_user.user_badges.create(:badge_id => 11)
    end
  when 12
    User.joins("INNER JOIN votes ON users.id = votes.voter_id AND votes.voter_type = 'User' and votes.votable_type = 'User'").select("users.*, count(users.id) as total_votes").group("users.id").having("total_votes >= #{badge[:minimum_limit]}").order("total_votes DESC").group("users.id").limit(badge[:daily_limit]).each do |top_user|
      next if top_user.blank? or top_user.user_badges.where(:badge_id => 12).first.present?
      top_user.user_badges.create(:badge_id => 12)
    end
  end
end
