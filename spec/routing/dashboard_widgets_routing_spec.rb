require "rails_helper"

RSpec.describe DashboardWidgetsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/dashboard_widgets").to route_to("dashboard_widgets#index")
    end

    it "routes to #new" do
      expect(get: "/dashboard_widgets/new").to route_to("dashboard_widgets#new")
    end

    it "routes to #show" do
      expect(get: "/dashboard_widgets/1").to route_to("dashboard_widgets#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/dashboard_widgets/1/edit").to route_to("dashboard_widgets#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/dashboard_widgets").to route_to("dashboard_widgets#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/dashboard_widgets/1").to route_to("dashboard_widgets#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/dashboard_widgets/1").to route_to("dashboard_widgets#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/dashboard_widgets/1").to route_to("dashboard_widgets#destroy", id: "1")
    end
  end
end
