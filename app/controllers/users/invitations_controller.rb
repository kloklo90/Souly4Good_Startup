class Users::InvitationsController < Devise::InvitationsController
	protect_from_forgery with: :null_session

  def batch_invite
	  #Validate the user_emails field isn't blank and emails are valid
	  @user = current_user

		puts "Progress start"	  
    puts Progress.where(user_id: current_user).first

    if not (Progress.where(user_id: current_user).first)
      puts "no Progress"
      Progress.create(user_id: current_user.id)
    end

    @progess = Progress.where(user_id: current_user).first
    # puts @progess.current_value
    params[:user_emails].each do |email|
      next if User.find_by_email(email).present?
      User.invite!({:email => email}, current_user)
      @progess.increment(3)
    end

	  @progess.save
	  
	  # return current Progress levels
	  render json: {"progess_level" => (@progess.current_value.to_f/ @progess.levelRange.to_f)*100, "progess_name" => Level.getLevel(@progess.level_key)}

	end

end