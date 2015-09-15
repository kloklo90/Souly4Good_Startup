class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise  :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :invitable
  mount_uploader :avatar, AvatarUploader
  has_many :posts
  has_many :user_badges
  has_many :comments
  has_one :progress
  acts_as_votable
  acts_as_voter
  after_create :create_progress, :create_user_first_badge

  def getProgress
  	if self.progress 
  		return self.progress 
  	else
  		create_progress
  	end
  	return self.progress 
  	
  end

  def full_name
    if self.name.present?
      return self.name
    else
      return friendly_name
    end
  end

  def friendly_name
    self.email.split("@").first
  end

  def to_param
    [id, full_name.parameterize].join("-")
  end

  def increment_invitations!
    self.update_attributes(:invitations_count => self.invitations_count + 1)
  end

  protected

  def create_user_first_badge
    self.user_badges.create(:badge_id => 1)
  end

end
