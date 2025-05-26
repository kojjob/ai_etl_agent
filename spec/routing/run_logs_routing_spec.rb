require "rails_helper"

RSpec.describe RunLogsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/run_logs").to route_to("run_logs#index")
    end

    it "routes to #new" do
      expect(get: "/run_logs/new").to route_to("run_logs#new")
    end

    it "routes to #show" do
      expect(get: "/run_logs/1").to route_to("run_logs#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/run_logs/1/edit").to route_to("run_logs#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/run_logs").to route_to("run_logs#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/run_logs/1").to route_to("run_logs#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/run_logs/1").to route_to("run_logs#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/run_logs/1").to route_to("run_logs#destroy", id: "1")
    end
  end
end
