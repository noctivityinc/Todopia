class Public::TodosController < PublicController
  before_filter :get_todo, :except => [:index, :new, :create, :reload, :filter, :reorder]
  after_filter :check_for_model_notice

  def index
    load_todos
    render :index
  end

  def show
  end

  def new
    @todo = current_user.todos.new
    respond_to do |format|
      format.js { render :partial => 'form' }
      format.html { render :action => 'edit' }
    end
  end

  def create
    @todo = current_user.todos.new(params[:todo])
    @todo.save ? render_list : render_list(500)
  end

  def edit
    setup_tags
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
    if @todo.update_attributes(params[:todo])
      render_list
    else
      render_list(500)
    end
    # ? render_list : render_list(500)
  end

  def check
    if @todo.update_attributes(:completed_at => Time.now, :completed_by  => current_user)
      flash.notice = "Todo marked as complete."
    else
      flash.error = "There was an error marking this todo as complete.  Please try again."
    end
    redirect_to user_todos_path(current_user)
  end

  def uncheck
    @todo.uncheck(current_user)
    render_list
  end

  def delete
    @todo.destroy
    render_list
  end

  def filter
    params[:unfiled] ? filter_without_tags : filter_by_tag
  end

  def move
    move_from = params[:move_from]
    move_to = params[:move_to]

    return unless @todo && move_from && move_to

    unless move_from == move_to
      @todo.tag_list = @todo.tag_list.to_a.reject {|x| x==move_from} unless move_from == '-99'
      @todo.tag_list.push(move_to) unless move_to =~ /^-(.*)/
      @todo.save
    end
    render_list
  end

  def reorder
    todo_list = params[:cb_todo]
    todo_list.each_with_index {|id, ndx| Todo.update(id,:priority => ndx+1)} if todo_list
    render_list
  end

  def wait
    @todo.toggle_waiting
    render_list
  end

  private

  def get_todo
    # => in case a todo was deleted and tries to be accessed
    @todo = Todo.find_by_id(params[:id])
    redirect_to user_todos_path(current_user) unless @todo
  end

  def verify_user()
    if (@todo.user != current_user) || !@todo.shared_with?(current_user)
      @user_session = UserSession.find
      @user_session.destroy
      flash.error = 'Unauthorized Access'
      redirect_to root_url
    end
  end

  def load_todos
    @todo = current_user.todos.new
    @todos = current_user.todos.not_complete
    @completed = (current_user.todos.complete + current_user.shared_todos.complete).sort {|a,b| a.completed_at <=> b.completed_at}.reverse
  end

  def setup_tags
    @todo.tag_list.push("due #{@todo.due_date.strftime('%m/%d/%Y')}") if @todo.due_date
    @todo.tag_list.push("starts #{@todo.starts_at.strftime('%m/%d/%Y')}") if @todo.starts_at
    @todo.tag_list.push('#!') if @todo.highlight
    @todo.tag_string = @todo.tag_list
  end

  def render_list(status=200)
    puts "XHR: #{request.xhr?}"
    check_for_model_notice
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
      @todo = current_user.todos.new
      @todos = current_user.todos.tagged_with(@tags, :any => false).not_complete
      @completed = current_user.todos.tagged_with(@tags, :any => false).complete
      render :partial => 'list'
    else
      render_list
    end
  end

  def check_for_model_notice
    flash.notice = @todo.notice if @todo && @todo.notice
    flash.warning = @todo.warning if @todo && @todo.warning
    flash.error = @todo.error if @todo && @todo.error
  end



end
