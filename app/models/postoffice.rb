class Postoffice < ActionMailer::Base
  ActionMailer::Base.default_url_options[:host] = APP_CONFIG[:domain]
  ActionController::Base.asset_host = APP_CONFIG[:domain]

  helper 'public/todos'

  def welcome(sent_at = Time.now)
    subject    'Postoffice#welcome'
    recipients ''
    from       ''
    sent_on    sent_at

    body       :greeting => 'Hi,'
  end

  def forgot_password(sent_at = Time.now)
    subject    'Postoffice#forgot_password'
    recipients ''
    from       ''
    sent_on    sent_at

    body       :greeting => 'Hi,'
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
