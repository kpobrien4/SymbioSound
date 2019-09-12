class SessionsController < ApplicationController
    layout 'home_layout'
  
    before_action :redirect_if_signed_in, except: [:destroy]
  
    def new
      @user = User.new
    end
  
    def create 
      if auth
        @user = User.find_or_create_by_omniauth(auth)
        session[:user_id] = @user.id
        redirect_to projects_path
      else
        @user = User.find_by(email: user_params[:email])
        if @user && @user.authenticate(user_params[:password])
          session[:user_id] = @user.id
          redirect_to projects_path
        else
          render :new
        end
      end
    end
  
    def destroy
      session.clear
      redirect_to root_path
    end
  
    private
      def user_params
        params.require(:user).permit(:email, :password)
      end

      def auth
        request.env['omniauth.auth']
      end
  end
