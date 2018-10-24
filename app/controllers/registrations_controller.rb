class RegistrationsController < Devise::RegistrationsController
  respond_to :json
  def new
    super
    # render json: {
    #     status: 'SUCCESS',
    #     message: "New message from RegistrationsController",
    #     data: "Riki add data here"
    # }, status: :ok
  end

  def create
    super
    # render json: {
    #     status: 'SUCCESS',
    #     message: "create message",
    #     data: "Riki add data here"
    # }, status: :ok
  end

  private

  def sign_up_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def account_update_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :current_password)
  end

end