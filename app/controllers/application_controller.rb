class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  
  # Ensure user authentication for all actions except those explicitly skipped
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?
  
  # Add helper methods for authorization
  helper_method :admin?, :can_access_resource?
  
  protected
  
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :role])
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name])
  end
  
  def admin?
    current_user&.admin?
  end
  
  def can_access_resource?(resource = nil)
    return false unless current_user
    return true if admin?
    
    # Resource-specific access control
    case resource
    when Project
      resource.user_id == current_user.id || resource.collaborators.include?(current_user)
    when Pipeline
      can_access_resource?(resource.project)
    else
      true # Default access for other resources
    end
  end
  
  def require_admin
    redirect_to root_path, alert: "Access denied. Admin privileges required." unless admin?
  end
end
