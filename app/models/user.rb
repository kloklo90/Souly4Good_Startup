class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise  :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :invitable
  mount_uploader :avatar, AvatarUploader
  has_many :posts
  has_one :progress
  after_create :create_progress

  def getProgress
  	if self.progress 
  		return self.progress 
  	else
  		create_progress
  		
  	end
  	
  	return self.progress 
  	
  end

end
