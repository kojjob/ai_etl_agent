require 'rails_helper'

RSpec.describe "pipelines/edit", type: :view do
  let(:pipeline) {
    Pipeline.create!(
      name: "MyString",
      description: "MyText",
      created_by_user: nil,
      project: nil,
      version: 1,
      status: "MyString",
      tags: "",
      ai_assisted_design_details: ""
    )
  }

  before(:each) do
    assign(:pipeline, pipeline)
  end

  it "renders the edit pipeline form" do
    render

    assert_select "form[action=?][method=?]", pipeline_path(pipeline), "post" do

      assert_select "input[name=?]", "pipeline[name]"

      assert_select "textarea[name=?]", "pipeline[description]"

      assert_select "input[name=?]", "pipeline[created_by_user_id]"

      assert_select "input[name=?]", "pipeline[project_id]"

      assert_select "input[name=?]", "pipeline[version]"

      assert_select "input[name=?]", "pipeline[status]"

      assert_select "input[name=?]", "pipeline[tags]"

      assert_select "input[name=?]", "pipeline[ai_assisted_design_details]"
    end
  end
end
