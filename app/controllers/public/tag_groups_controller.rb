class Public::TagGroupsController < PublicController
  before_filter :get_tag_group, :except => [:delete_unfiled, :check_unfiled]

  def remove
    @tag_group.destroy
    render :text => nil
  end

  def delete
    @tag_group.destroy
    @user.todos.not_complete.tagged_with(@tag_group.tag).each {|x| x.destroy}
    render :text => nil
  end

  def check_all
    @user.todos.not_complete.tagged_with(@tag_group.tag).each do |todo|
      todo.completed_by = current_user
      todo.completed_at = Time.now
      todo.save
    end
    render :text => nil
  end

  def delete_unfiled
    current_user.todos.unfiled.each {|x| x.destroy}
    render :text => nil
  end

  def check_unfiled
    current_user.todos.unfiled.each do |todo|
      todo.completed_by = current_user
      todo.completed_at = Time.now
      todo.save
    end
    render :text => nil
  end

  private

  def get_tag_group
    @tag_group = TagGroup.find(params[:id])
    @user = @tag_group.user
  end


end
