class RegistrationsController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      session[:user_id] = @user.id
      redirect_to root_path, notice: 'Successfully created account!'
    else
      flash.now[:alert] = 'Failed to create account. Please try again.'
      render :new
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
  end

  private

  def user_params
    params.expect(user: [:email, :password, :password_confirmation])
  end
end
