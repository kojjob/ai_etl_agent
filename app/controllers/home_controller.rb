class HomeController < ApplicationController
  # Skip authentication for landing page
  before_action :authenticate_user!, except: [:index, :demo, :docs]

  def index
    if user_signed_in?
      redirect_to dashboard_path
    end
  end

  def demo
  end

  def docs
  end
  
  private
  
  def dashboard_path
    # Redirect to appropriate dashboard based on user role
    if current_user.admin?
      dashboards_path
    else
      projects_path
    end
  end
end
