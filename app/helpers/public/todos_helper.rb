module Public::TodosHelper
  def notes_icon(todo)
    if todo.notes.empty?
      image_tag "icons/note.png", :title => "+ Add Note", :class => 'icon'
    elsif todo.notes.detect {|x| x.user != current_user}
      image_tag "icons/comments_red.png", :title => "+ Add Note", :class => 'icon'
    else
      image_tag "icons/comments_green.png", :title => "+ Add Note", :class => 'icon'
    end
  end

  def tag_css(tag)
    'selected' if (@tags && @tags.include?(tag))
  end

  def tag_rel_url(todo, tag)
    (@tags && @tags.include?(tag)) ? filter_user_todos_path(current_user, :tag => tag, :remove => true)  : filter_user_todos_path(current_user, :tag => tag)
  end
  
  def todo_css(todo)
    (css ||= []) << 'waiting' if todo.waiting_since
    (css ||= []) << 'blink' if todo.due_date && todo.due_date <= Date.today && !todo.waiting_since
    css.join(' ') if css
  end

  def todo_cb_css(todo)
    todo.waiting_since ? 'vanish' : ''
  end

  def show_due_date(todo)
    return "&nbsp;" unless todo.due_date
    "<div class='due_date #{todo.due_date > Date.today ? '' : 'past_due'}'>#{todo.due_date.strftime('%m/%d/%Y')}</div>"
  end

  def show_notes(todo)
    if todo.notes.empty?
      link_to (notes_icon(todo)), todo_notes_path(todo), :rel => 'facebox', :class => 'note_trigger icon'
    else
      link_to (notes_icon(todo)), todo_notes_path(todo), :rel => 'facebox', :class => 'note_trigger icon note_list', 'url:showmin' => list_todo_notes_path(todo)
    end
  end

  def show_waiting(todo)
    if todo.waiting_since
      link_to  image_tag("icons/waiting.png", :title => "since #{todo.waiting_since.strftime('%m/%d/%Y')}.  click or (w) to resume", :class => "icon"), '#', :class => 'wait_todo', :rel => wait_todo_path(todo)
    else
      link_to image_tag("icons/clock.png", :title => "in process...", :class => "icon"), '#', :class => 'wait_todo', :rel => wait_todo_path(todo)
    end
  end

  def tag_groups_empty?(user=nil)
    user ||= current_user
    if user.tag_groups.empty?
      return true
    else
      return @todos.tagged_with(user.tag_groups.map {|x| x.tag}, :any => true).empty?
    end
  end

  def unfiled_todos(scope=nil, user=nil)
    user ||= current_user
    if user.tag_groups.empty?
      @todos
    else
      if scope
        @todos.send(scope.intern).tagged_with(user.tag_groups.map {|x| x.tag}.join(','), :exclude => true)
      else
        @todos.tagged_with(user.tag_groups.map {|x| x.tag}.join(','), :exclude => true)
      end
    end
  end
end
