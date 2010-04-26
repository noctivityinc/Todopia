class Postoffice < ActionMailer::Base
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

  def email_todos(user, sent_at = Time.now)
    subject    "Todopia Todos as of #{Date.today.to_s{:short}}"
    recipients user.email
    from       APP_CONFIG[:emails]["todo"]
    sent_on    sent_at
    content_type 'text/plain'
    
    body       :user => user, :todos => user.todos.not_complete
  end

end
