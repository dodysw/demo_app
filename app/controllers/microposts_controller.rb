class MicropostsController < ApplicationController
    before_action :signed_in_user, only: [:create, :destroy]
    before_action :correct_user, only: :destroy

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
        redirect_to root_url
    end

    private
    def set_micropost
        @micropost = Micropost.find(params[:id])
    end

    def micropost_params
        params.require(:micropost).permit(:content)
    end

    def correct_user
        @micropost = current_user.microposts.find_by(id: params[:id])
        redirect_to root_url if @micropost.nil?
    end
end
