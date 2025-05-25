class HomeController < ApplicationController
  # Skip authentication for landing page
  # before_action :authenticate_user!, except: [:index, :demo, :docs]
  
  def index
  end
  
  def demo
  end
  
  def docs
  end
end
