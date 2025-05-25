require "rails_helper"

RSpec.describe PipelineStepRunsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/pipeline_step_runs").to route_to("pipeline_step_runs#index")
    end

    it "routes to #new" do
      expect(get: "/pipeline_step_runs/new").to route_to("pipeline_step_runs#new")
    end

    it "routes to #show" do
      expect(get: "/pipeline_step_runs/1").to route_to("pipeline_step_runs#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/pipeline_step_runs/1/edit").to route_to("pipeline_step_runs#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/pipeline_step_runs").to route_to("pipeline_step_runs#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/pipeline_step_runs/1").to route_to("pipeline_step_runs#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/pipeline_step_runs/1").to route_to("pipeline_step_runs#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/pipeline_step_runs/1").to route_to("pipeline_step_runs#destroy", id: "1")
    end
  end
end
