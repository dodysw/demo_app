class MicropostsController < ApplicationController
    before_action :signed_in_user, only: [:create, :destroy]

  def index
    @microposts = Micropost.all
  end

  def show
  end

  def new
    @micropost = Micropost.new
  end

  def edit
  end

  def create
    @micropost = current_user.microposts.build(micropost_params)
    if @micropost.save
        flash[:success] = "Micropost created!"
        redirect_to root_url
    else
        @feed_items = []
        render "static_pages/home"
    end
  end

  def destroy
    @micropost.destroy
    respond_to do |format|
      format.html { redirect_to microposts_url }
      format.json { head :no_content }
    end
  end

  private
    def set_micropost
      @micropost = Micropost.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def micropost_params
      params.require(:micropost).permit(:content)
    end
end
