class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise  :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :invitable
  mount_uploader :avatar, AvatarUploader
  has_many :posts
  has_one :progress
  after_create :create_progress

end
