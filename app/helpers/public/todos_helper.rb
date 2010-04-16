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
end
