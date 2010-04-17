class Public::TodosController < PublicController
  before_filter :get_user, :only => [:index, :new, :create, :update_order]
  before_filter :get_todo, :except => [:index, :new, :create, :update_order]
  before_filter :verify_user

  def index
    load_todos
    render_list
  end

  def show
  end

  def new
    @todo = @user.todos.new
    respond_to do |format|
      format.js { render :partial => 'form' }
      format.html { render :action => 'edit' }
    end
  end

  def create
    @todo = @user.todos.new(params[:todo])
    @todo.save
    render_list
  end

  def edit
    @todo.tag_string = @todo.tag_list
    respond_to do |format|
      format.js { render :partial => 'form' }
      format.html { render :action => 'edit' }
    end
  end

  def update
    @todo.completed_by = current_user
    render_list if @todo.update_attributes(params[:todo])
  end

  def delete
    @todo.destroy
    render_list
  end

  def filter
    tag = params[:tag]
    @tags = cookies[:tags].blank? ? [] : cookies[:tags].split(",")

    if params[:remove]
      @tags.reject! {|x| x == tag}
    else
      @tags << tag
    end

    cookies[:tags] = @tags.join(',')

    unless @tags.empty?
      @todo = @user.todos.new
      @todos = @user.todos.tagged_with(@tags, :any => true).not_complete
      @completed = @user.todos.tagged_with(@tags, :any => true).complete
      render :partial => 'list'
    else
      render_list
    end
  end

  def update_order
    todo_order = params[:cb_todo]
    todo_order.each_with_index do |id, ndx|
      Todo.update(id, {:position => ndx})
    end
  end

  private

  def get_user
    @user = User.find(params[:user_id])
  end

  def get_todo
    @todo = Todo.find(params[:id])
    @user = @todo.user
  end

  def load_todos
    @todo = @user.todos.new
    @todos = @user.todos.not_complete
    @completed = @user.todos.complete
  end

  def render_list
    puts "XHR: #{request.xhr?}"
    respond_to do |format|
      format.js {
        load_todos
        render :partial => 'list'
      }
      format.html {  }
    end
  end
end
