require 'rails_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to test the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator. If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails. There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.

RSpec.describe "/pipelines", type: :request do
  # This should return the minimal set of attributes required to create a valid
  # Pipeline. As you add validations to Pipeline, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    skip("Add a hash of attributes valid for your model")
  }

  let(:invalid_attributes) {
    skip("Add a hash of attributes invalid for your model")
  }

  describe "GET /index" do
    it "renders a successful response" do
      Pipeline.create! valid_attributes
      get pipelines_url
      expect(response).to be_successful
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      pipeline = Pipeline.create! valid_attributes
      get pipeline_url(pipeline)
      expect(response).to be_successful
    end
  end

  describe "GET /new" do
    it "renders a successful response" do
      get new_pipeline_url
      expect(response).to be_successful
    end
  end

  describe "GET /edit" do
    it "renders a successful response" do
      pipeline = Pipeline.create! valid_attributes
      get edit_pipeline_url(pipeline)
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new Pipeline" do
        expect {
          post pipelines_url, params: { pipeline: valid_attributes }
        }.to change(Pipeline, :count).by(1)
      end

      it "redirects to the created pipeline" do
        post pipelines_url, params: { pipeline: valid_attributes }
        expect(response).to redirect_to(pipeline_url(Pipeline.last))
      end
    end

    context "with invalid parameters" do
      it "does not create a new Pipeline" do
        expect {
          post pipelines_url, params: { pipeline: invalid_attributes }
        }.to change(Pipeline, :count).by(0)
      end

      it "renders a response with 422 status (i.e. to display the 'new' template)" do
        post pipelines_url, params: { pipeline: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      let(:new_attributes) {
        skip("Add a hash of attributes valid for your model")
      }

      it "updates the requested pipeline" do
        pipeline = Pipeline.create! valid_attributes
        patch pipeline_url(pipeline), params: { pipeline: new_attributes }
        pipeline.reload
        skip("Add assertions for updated state")
      end

      it "redirects to the pipeline" do
        pipeline = Pipeline.create! valid_attributes
        patch pipeline_url(pipeline), params: { pipeline: new_attributes }
        pipeline.reload
        expect(response).to redirect_to(pipeline_url(pipeline))
      end
    end

    context "with invalid parameters" do
      it "renders a response with 422 status (i.e. to display the 'edit' template)" do
        pipeline = Pipeline.create! valid_attributes
        patch pipeline_url(pipeline), params: { pipeline: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested pipeline" do
      pipeline = Pipeline.create! valid_attributes
      expect {
        delete pipeline_url(pipeline)
      }.to change(Pipeline, :count).by(-1)
    end

    it "redirects to the pipelines list" do
      pipeline = Pipeline.create! valid_attributes
      delete pipeline_url(pipeline)
      expect(response).to redirect_to(pipelines_url)
    end
  end
end
