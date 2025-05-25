require "rails_helper"

RSpec.describe AlertRulesController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/alert_rules").to route_to("alert_rules#index")
    end

    it "routes to #new" do
      expect(get: "/alert_rules/new").to route_to("alert_rules#new")
    end

    it "routes to #show" do
      expect(get: "/alert_rules/1").to route_to("alert_rules#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/alert_rules/1/edit").to route_to("alert_rules#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/alert_rules").to route_to("alert_rules#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/alert_rules/1").to route_to("alert_rules#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/alert_rules/1").to route_to("alert_rules#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/alert_rules/1").to route_to("alert_rules#destroy", id: "1")
    end
  end
end
