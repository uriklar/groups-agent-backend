class UserMailer < ActionMailer::Base
  default from: "from@example.com"

  def daily_digest(user)
  	@user = user
  	@results = @user.results
  	mail(to: @user.email, subject: "Your daily digest from Facebook Group Agent")
  end
end
