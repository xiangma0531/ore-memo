class ApplicationController < ActionController::Base
  befoer_action :devise_parameter_sanitizer, if: :devise_controller?

  def configure_permitted_parameter
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
  end
end
