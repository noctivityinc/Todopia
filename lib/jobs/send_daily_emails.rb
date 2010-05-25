class SendDailyEmails
  def process
    User.wanting_daily_emails.each do |user|
      unless (user.todos.not_complete + user.shared_todos.not_complete).empty?
        user.update_attribute(:daily_summary_sent_at, Time.now) if Postoffice.deliver_email_todos(user)
      end
    end
  end
end
