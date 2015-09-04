class Post < ActiveRecord::Base
	PTYPE = {external: 'external', user: 'regular', challenge: 'challenge'}
	acts_as_votable
	belongs_to :user
	has_many :comments
	mount_uploader :image, ImageUploader

	has_many :replies, -> { order "created_at desc" } , class_name: "Post", foreign_key: "post_id"
	belongs_to :parent, class_name: "Post", foreign_key: "post_id"

	validates :title, presence: true

	paginates_per 8

	def external_image
		external_image_url || image
	end

end
