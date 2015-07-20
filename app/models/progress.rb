class Progress < ActiveRecord::Base
  belongs_to :users

	@@level_point = 100 

  def increment(value)
  	self.level_key = self.level_key + ((value + self.current_value)/@@level_point).floor 
  	self.current_value = (self.current_value + value) % @@level_point
  end

  def self.get_progress_val(post_type)
      case post_type
        when "regular"
          return 3
        when "challenge"  
          return 1
        when "external"  
          return 1
        else 
          return 0
      end
      
  end

  def levelRange
    @@level_point
  end
end
