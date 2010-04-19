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

  def tag_background(tag)
    (@tags && @tags.include?(tag)) ? 'url(/images/tag_selected.gif)' : 'url(/images/tag.gif)'
  end

  def tag_rel_url(todo, tag)
    (@tags && @tags.include?(tag)) ? filter_todo_path(todo, :tag => tag, :remove => true)  : filter_todo_path(todo, :tag => tag)
  end

  def show_due_date(todo)
    return unless todo.due_date
    "<div class='col_due col due_date#{todo.due_date > Date.today ? '' : '_past_due'}'>(Due: #{todo.due_date.strftime('%m/%d/%Y')})</div>"
  end

  def show_notes(todo)
    if todo.notes.empty?
      link_to (notes_icon(todo)), todo_notes_path(todo), :rel => 'facebox', :class => 'note_trigger icon'
    else
      link_to (notes_icon(todo)), todo_notes_path(todo), :rel => 'facebox', :class => 'note_trigger icon note_list', 'url:showmin' => list_todo_notes_path(todo)
    end
  end
  
  def tag_groups_empty?
    if current_user.tag_groups.empty?
      return true
    else
      return @todos.tagged_with(current_user.tag_groups.map {|x| x.tag}, :any => true).empty?
    end
  end

  def todos_without_tags
    if current_user.tag_groups.empty?
      @todos
    else
      @todos.tagged_with(current_user.tag_groups.map {|x| x.tag}.join(','), :exclude => true)
    end
  end
end
