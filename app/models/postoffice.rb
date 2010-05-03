class Postoffice < ActionMailer::Base
  ActionMailer::Base.default_url_options[:host] = APP_CONFIG[:host]
  ActionController::Base.asset_host = APP_CONFIG[:domain]

  helper 'public/todos'

  def welcome(sent_at = Time.now)
    subject    'Postoffice#welcome'
    recipients ''
    from       ''
    sent_on    sent_at

    body       :greeting => 'Hi,'
  end

  def password_reset_instructions(user)
    subject       "Todopia login and password reset information"
    from          APP_CONFIG[:emails]["todo"]
    recipients    user.email
    sent_on       Time.now

    body          :edit_password_reset_url => edit_reset_password_url(user.perishable_token), :user => user
  end

  def share(sent_at = Time.now)
    subject    'Postoffice#share'
    recipients ''
    from       ''
    sent_on    sent_at

    body       :greeting => 'Hi,'
  end

  def email_todos(user, force_all=nil, sent_at = Time.now)
    subject    "#{'Overdue ' if user.email_summary_only_when_todos_due}Todopia Todos as of #{Date.today.to_s{:short}}"
    recipients user.email
    from       APP_CONFIG[:emails]["todo"]
    sent_on    sent_at
    content_type    "multipart/alternative"

    body       :user => user, :todos => (user.email_summary_only_when_todos_due && !force_all) ? user.todos.not_complete.due : user.todos.not_complete
  end

end
