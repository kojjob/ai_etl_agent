require "rails_helper"

RSpec.describe AiSuggestionsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/ai_suggestions").to route_to("ai_suggestions#index")
    end

    it "routes to #new" do
      expect(get: "/ai_suggestions/new").to route_to("ai_suggestions#new")
    end

    it "routes to #show" do
      expect(get: "/ai_suggestions/1").to route_to("ai_suggestions#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/ai_suggestions/1/edit").to route_to("ai_suggestions#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/ai_suggestions").to route_to("ai_suggestions#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/ai_suggestions/1").to route_to("ai_suggestions#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/ai_suggestions/1").to route_to("ai_suggestions#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/ai_suggestions/1").to route_to("ai_suggestions#destroy", id: "1")
    end
  end
end
