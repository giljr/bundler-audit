class PasswordsController < ApplicationController
  before_action :require_user_logged_in

  # GET /password
  def edit
    # The form will use Current.user
  end

  # PATCH /password
  def update
    if Current.user.update(password_params)
      redirect_to root_path, notice: 'Password updated!'
    else
      # Return 200 OK so that integration tests expecting a form render work
      render :edit, status: :unprocessable_content
    end
  end

  private

  # Only permit password and password_confirmation parameters
  def password_params
    params.require(:user).permit(:password, :password_confirmation)
  end
end
