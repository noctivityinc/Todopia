class Public::NotesController < PublicController
  before_filter :get_todo, :only => [:index, :new, :create]
  before_filter :get_note, :only => [:show, :edit, :update, :destroy, :delete]

  layout false

  def index
    @notes = @todo.notes.all
    @note = @todo.notes.new
  end

  def show
  end

  def new
    @note = @todo.notes.new
  end

  def create
    @note = @todo.notes.new(params[:note])
    @note.user = current_user
    @note.save
    render_notes
  end

  def delete
    @note.destroy
    render_notes
  end

  private

  def get_todo
    @todo = Todo.find(params[:todo_id])
  end

  def get_note
    @note = Note.find(params[:id])
    @todo = @note.todo
  end

  def render_notes
    @notes = @todo.notes.all
    render :partial => @notes
  end
end
