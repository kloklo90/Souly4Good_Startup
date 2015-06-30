class Post < ActiveRecord::Base
	PTYPE = {external: 'external', user: 'regular', challenge: 'challenge'}
	acts_as_votable
	belongs_to :user
	has_many :comments
	mount_uploader :image, ImageUploader

	validates :title, presence: true
end
