class Post < ActiveRecord::Base
	PTYPE = {external: 'external', user: 'regular', challenge: 'challenge'}
	acts_as_votable
	belongs_to :user
	has_many :comments
	mount_uploader :image, ImageUploader

	has_many :replies, -> { order "created_at desc" } , class_name: "Post", foreign_key: "post_id"
	belongs_to :parent, class_name: "Post", foreign_key: "post_id"

	validates :title, presence: true

  after_create :assign_badge

	paginates_per 8

	def external_image
		external_image_url || image
	end

  def challenge?
    !!(self.post_type == PTYPE[:challenge])
  end

  protected

  def assign_badge
    if self.user.present? and self.user.posts.present? and self.user.posts.count >= 1
      self.user.user_badges.create(:badge_id => 2) if self.user.user_badges.where(:badge_id => 2).first.blank?
      if self.user.posts.count >= 1000
        self.user.user_badges.create(:badge_id => 15) if self.user.user_badges.where(:badge_id => 15).first.blank?
      end
    end
  end

end
