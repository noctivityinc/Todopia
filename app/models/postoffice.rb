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

  def share(sharee, todo, sent_at = Time.now)
    subject    "#{todo.user.login} has shared a todo with you."
    recipients sharee.email
    from       todo.user.email
    sent_on    sent_at

    body       :todo => todo,  :user => todo.user, :sharee => sharee 
  end

  def removed_share(to_email, share, sent_at = Time.now)
    subject    "#{share.user.login} has been removed from a shared todo."
    recipients to_email
    from       APP_CONFIG[:emails]["todo"]
    sent_on    sent_at

    body       :todo => share.todo,  :user => share.todo.user, :sharee => share.user 
  end
  
  def invite_and_share(invite, todo, sent_at = Time.now)
    subject    "#{invite.user.login} has shared a todo with you on Todopia.com"
    recipients invite.email
    from       invite.user.email
    sent_on    sent_at

    body       :todo => todo, :user => invite.user, :invite_url => invite_url(invite.token)
  end
  
  def invitation_accepted(invite, user, sent_at = Time.now)
    subject    "#{user.login} has accepted your Todopia.com invitation."
    recipients invite.user.email
    from       APP_CONFIG[:emails]["todo"]
    sent_on    sent_at

    body       :user => user, :invite => invite  
  end
  
  def todo_complete(todo, user, sent_at = Time.now)
    subject    "A shared todo has been completed"
    recipients user.email
    from       APP_CONFIG[:emails]["todo"]
    sent_on    sent_at

    body       :todo => todo, :user => user
  end
  
  def todo_unchecked(todo, user, current_user, sent_at = Time.now)
    subject    "A shared todo has been reactivated"
    recipients user.email
    from       APP_CONFIG[:emails]["todo"]
    sent_on    sent_at

    body       :todo => todo, :user => user, :current_user => current_user 
  end
  
  def note_added(note, user, sent_at = Time.now)
    subject    "A new note has been posted to a mutual todo"
    recipients user.email
    from       APP_CONFIG[:emails]["todo"]
    sent_on    sent_at

    body       :note => note, :user => user
  end

  def email_todos(user, force_all=nil, sent_at=Time.now)
    subject    "#{'Overdue ' if user.email_summary_only_when_todos_due}Todopia Todos as of #{Date.today.to_s{:short}}"
    recipients user.email
    from       APP_CONFIG[:emails]["todo"]
    sent_on    sent_at

    body       :user => user, :todos => (user.email_summary_only_when_todos_due && !force_all) ? user.todos.not_complete.due : user.todos.not_complete, :shared => user.shared_todos.not_complete 
  end

end
