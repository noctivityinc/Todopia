class SendDailyEmails
  def self.process
    User.wanting_daily_emails.each do |user|
      user.update_attribute(:daily_summary_sent_at, Time.now) if Postoffice.deliver_email_todos(user)
    end
  end
end
