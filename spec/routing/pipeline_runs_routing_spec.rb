require "rails_helper"

RSpec.describe PipelineRunsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/pipeline_runs").to route_to("pipeline_runs#index")
    end

    it "routes to #new" do
      expect(get: "/pipeline_runs/new").to route_to("pipeline_runs#new")
    end

    it "routes to #show" do
      expect(get: "/pipeline_runs/1").to route_to("pipeline_runs#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/pipeline_runs/1/edit").to route_to("pipeline_runs#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/pipeline_runs").to route_to("pipeline_runs#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/pipeline_runs/1").to route_to("pipeline_runs#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/pipeline_runs/1").to route_to("pipeline_runs#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/pipeline_runs/1").to route_to("pipeline_runs#destroy", id: "1")
    end
  end
end
