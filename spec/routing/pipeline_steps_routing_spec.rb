require "rails_helper"

RSpec.describe PipelineStepsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/pipeline_steps").to route_to("pipeline_steps#index")
    end

    it "routes to #new" do
      expect(get: "/pipeline_steps/new").to route_to("pipeline_steps#new")
    end

    it "routes to #show" do
      expect(get: "/pipeline_steps/1").to route_to("pipeline_steps#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/pipeline_steps/1/edit").to route_to("pipeline_steps#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/pipeline_steps").to route_to("pipeline_steps#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/pipeline_steps/1").to route_to("pipeline_steps#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/pipeline_steps/1").to route_to("pipeline_steps#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/pipeline_steps/1").to route_to("pipeline_steps#destroy", id: "1")
    end
  end
end
