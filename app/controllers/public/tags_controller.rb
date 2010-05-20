class Public::TagsController < PublicController
  
  def show
    user = User.find(params[:user_id])
    render :text => '' unless user
    
    tags = (user.todos.map {|x| x.tags}.flatten.map {|x| [x.name, x.name]}.uniq || {})
    render :text => tags.to_json
  end

end
