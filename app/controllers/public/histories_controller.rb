class Public::HistoriesController < PublicController
  def index
    @histories = History.all
  end
  
  def show
    @history = History.find(params[:id])
  end
  
  def new
    @history = History.new
  end
  
  def create
    @history = History.new(params[:history])
    if @history.save
      flash[:notice] = "Successfully created history."
      redirect_to @history
    else
      render :action => 'new'
    end
  end
  
  def edit
    @history = History.find(params[:id])
  end
  
  def update
    @history = History.find(params[:id])
    if @history.update_attributes(params[:history])
      flash[:notice] = "Successfully updated history."
      redirect_to @history
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @history = History.find(params[:id])
    @history.destroy
    flash[:notice] = "Successfully destroyed history."
    redirect_to histories_url
  end
end
