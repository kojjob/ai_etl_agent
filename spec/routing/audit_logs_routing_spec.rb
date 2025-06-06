require "rails_helper"

RSpec.describe AuditLogsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/audit_logs").to route_to("audit_logs#index")
    end

    it "routes to #new" do
      expect(get: "/audit_logs/new").to route_to("audit_logs#new")
    end

    it "routes to #show" do
      expect(get: "/audit_logs/1").to route_to("audit_logs#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/audit_logs/1/edit").to route_to("audit_logs#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/audit_logs").to route_to("audit_logs#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/audit_logs/1").to route_to("audit_logs#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/audit_logs/1").to route_to("audit_logs#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/audit_logs/1").to route_to("audit_logs#destroy", id: "1")
    end
  end
end
