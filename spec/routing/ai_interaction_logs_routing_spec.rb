require "rails_helper"

RSpec.describe AiInteractionLogsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/ai_interaction_logs").to route_to("ai_interaction_logs#index")
    end

    it "routes to #new" do
      expect(get: "/ai_interaction_logs/new").to route_to("ai_interaction_logs#new")
    end

    it "routes to #show" do
      expect(get: "/ai_interaction_logs/1").to route_to("ai_interaction_logs#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/ai_interaction_logs/1/edit").to route_to("ai_interaction_logs#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/ai_interaction_logs").to route_to("ai_interaction_logs#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/ai_interaction_logs/1").to route_to("ai_interaction_logs#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/ai_interaction_logs/1").to route_to("ai_interaction_logs#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/ai_interaction_logs/1").to route_to("ai_interaction_logs#destroy", id: "1")
    end
  end
end
