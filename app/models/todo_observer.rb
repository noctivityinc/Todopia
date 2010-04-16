class TodoObserver < ActiveRecord::Observer
  def after_create(todo)
    todo.histories.create(:event => 'created', :user => todo.user)
  end

  def after_update(todo)
    if todo.completed
      todo.histories.create(:event =>'completed', :user => todo.completer)
    else
      changes = todo.changes.reject {|k,v| %w{updated_at created_at}.include?(k) }
      todo.histories.create(:event => "updated #{changes}", :user => todo.user)
    end
  end
end
