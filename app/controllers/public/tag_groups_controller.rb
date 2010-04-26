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

  def rename
    unless params[:name].blank?
      @user.tag_groups.find_by_tag(params[:name]).delete rescue nil
      @user.todos.not_complete.each {|x| x.rename_tag(@tag_group.tag, params[:name])}
      @tag_group.update_attributes(:tag => params[:name])
    end
    render :text => nil, :status => 200
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
