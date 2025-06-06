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

RSpec.describe "/dashboards", type: :request do
  # This should return the minimal set of attributes required to create a valid
  # Dashboard. As you add validations to Dashboard, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    skip("Add a hash of attributes valid for your model")
  }

  let(:invalid_attributes) {
    skip("Add a hash of attributes invalid for your model")
  }

  describe "GET /index" do
    it "renders a successful response" do
      Dashboard.create! valid_attributes
      get dashboards_url
      expect(response).to be_successful
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      dashboard = Dashboard.create! valid_attributes
      get dashboard_url(dashboard)
      expect(response).to be_successful
    end
  end

  describe "GET /new" do
    it "renders a successful response" do
      get new_dashboard_url
      expect(response).to be_successful
    end
  end

  describe "GET /edit" do
    it "renders a successful response" do
      dashboard = Dashboard.create! valid_attributes
      get edit_dashboard_url(dashboard)
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new Dashboard" do
        expect {
          post dashboards_url, params: { dashboard: valid_attributes }
        }.to change(Dashboard, :count).by(1)
      end

      it "redirects to the created dashboard" do
        post dashboards_url, params: { dashboard: valid_attributes }
        expect(response).to redirect_to(dashboard_url(Dashboard.last))
      end
    end

    context "with invalid parameters" do
      it "does not create a new Dashboard" do
        expect {
          post dashboards_url, params: { dashboard: invalid_attributes }
        }.to change(Dashboard, :count).by(0)
      end

      it "renders a response with 422 status (i.e. to display the 'new' template)" do
        post dashboards_url, params: { dashboard: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      let(:new_attributes) {
        skip("Add a hash of attributes valid for your model")
      }

      it "updates the requested dashboard" do
        dashboard = Dashboard.create! valid_attributes
        patch dashboard_url(dashboard), params: { dashboard: new_attributes }
        dashboard.reload
        skip("Add assertions for updated state")
      end

      it "redirects to the dashboard" do
        dashboard = Dashboard.create! valid_attributes
        patch dashboard_url(dashboard), params: { dashboard: new_attributes }
        dashboard.reload
        expect(response).to redirect_to(dashboard_url(dashboard))
      end
    end

    context "with invalid parameters" do
      it "renders a response with 422 status (i.e. to display the 'edit' template)" do
        dashboard = Dashboard.create! valid_attributes
        patch dashboard_url(dashboard), params: { dashboard: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested dashboard" do
      dashboard = Dashboard.create! valid_attributes
      expect {
        delete dashboard_url(dashboard)
      }.to change(Dashboard, :count).by(-1)
    end

    it "redirects to the dashboards list" do
      dashboard = Dashboard.create! valid_attributes
      delete dashboard_url(dashboard)
      expect(response).to redirect_to(dashboards_url)
    end
  end
end
