class ReportMailer < ActionMailer::Base
  default from: "noreply@souly4good.com"

  def report_post(post, user)
    @user = user
    @post  = post
    mail(to: "souly4good@gmail.com", cc: "omerpucit@gmail.com", subject: "#{user.friendly_name} has reported post")
  end

end
