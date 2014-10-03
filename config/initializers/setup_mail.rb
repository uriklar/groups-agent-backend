ActionMailer::Base.smtp_settings = {
  :address              => "smtp.gmail.com",
  :port                 => 587,
  :domain               => "asciicasts.com",
  :user_name            => "fb.group.agent",
  :password             => "1234.com",
  :authentication       => "plain",
  :enable_starttls_auto => true
}