class Public::TodosController < PublicController
  before_filter :get_user, :only => [:index, :new, :create, :reload, :update_order, :filter]
  before_filter :get_todo, :except => [:index, :new, :create, :reload, :update_order, :filter]
  before_filter :verify_user

  def index
    load_todos
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
    @todo.save ? render_list : render_list(500)
  end

  def edit
    @todo.tag_string = @todo.tag_list
    respond_to do |format|
      format.js { render :partial => 'form' }
      format.html { render :action => 'edit' }
    end
  end

  def reload
    render_list
  end

  def update
    @todo.completed_by = current_user
    @todo.update_attributes(params[:todo]) ? render_list : render_list(500)
  end

  def uncheck
    @todo.completed_by = @todo.completed_at = nil
    @todo.save
    render_list
  end

  def delete
    @todo.destroy
    render_list
  end

  def filter
    params[:unfiled] ? filter_without_tags : filter_by_tag
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

  def render_list(status=200)
    puts "XHR: #{request.xhr?}"
    respond_to do |format|
      format.js {
        load_todos
        render :partial => 'list', :status => status
      }
      format.html { }
    end
  end

  def filter_without_tags
    load_todos
    @todos = current_user.todos.unfiled
    render :partial => 'list'
  end

  def filter_by_tag
    tag = params[:tag]
    @tags = cookies[:tags].blank? ? [] : cookies[:tags].split(",")

    if params[:remove]
      @tags.reject! {|x| x == tag}
    else
      @tags << tag unless tag.blank?
    end

    cookies[:tags] = @tags.join(',')

    unless @tags.empty?
      @todo = @user.todos.new
      @todos = @user.todos.tagged_with(@tags, :any => false).not_complete
      @completed = @user.todos.tagged_with(@tags, :any => false).complete
      render :partial => 'list'
    else
      render_list
    end
  end

end
