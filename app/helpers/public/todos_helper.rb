module Public::TodosHelper
  def notes_icon(todo)
    if todo.notes.empty?
      image_tag "icons/note.png", :title => "+ Add Note"
    elsif todo.notes.detect {|x| x.user != current_user}
      image_tag "icons/comments_red.png", :title => "+ Add Note"
    else
      image_tag "icons/comments_green.png", :title => "+ Add Note"
    end
  end
end
