class NoteObserver < ActiveRecord::Observer
  def after_create(note)
    note.todo.histories.create(:event => 'note added', :user => note.user)
  end

  def after_update(note)
    note.todo.histories.create(:event => 'note edited', :user => note.user)
  end
  
  def after_destroy(note)
    note.todo.histories.create(:event => 'note deleted', :user => note.user)    
  end
end
