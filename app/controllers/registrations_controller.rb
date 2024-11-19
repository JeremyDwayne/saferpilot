class RegistrationsController < ApplicationController
  allow_unauthenticated_access only: %i[new create]
  rate_limit to: 10, within: 3.minutes, only: :create, with: -> { redirect_to new_session_url, alert: "Try again later." }

  def new
    redirect_to root_url if authenticated?
  end

  def create
    user = User.new(registration_params)
    if user.save
      start_new_session_for user
      redirect_to after_authentication_url, notice: "Signed up."
    else
      redirect_to new_registration_url, alert: "Unable to sign up."
    end
  end

  def destroy
    terminate_session
    redirect_to new_session_path
  end

  private

  def registration_params
    params.permit(:email_address, :password, :password_confirmation)
  end
end
