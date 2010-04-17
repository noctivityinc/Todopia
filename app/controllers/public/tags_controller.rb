class Public::TagsController < PublicController
  
  def show
    user = User.find_by_id(params[:user_id])
    render :text => '' unless user
    
    tags = user.todos.map {|x| x.tags}.flatten.map {|x| [x.name, x.name]}.uniq!
    render :text => tags.to_json
  end

end
