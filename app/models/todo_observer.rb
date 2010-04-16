class TodoObserver < ActiveRecord::Observer
  def after_create(todo)
    todo.histories.create(:event => 'created', :user => todo.user)
  end

  def after_update(todo)
    if todo.completed
      todo.histories.create(:event =>'completed', :user => todo.completer)
    else
      todo.histories.create(:event => 'updated', :user => todo.user)
    end
  end
end
