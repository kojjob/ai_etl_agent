require 'rails_helper'

RSpec.describe "pipelines/new", type: :view do
  before(:each) do
    assign(:pipeline, Pipeline.new(
      name: "MyString",
      description: "MyText",
      created_by_user: nil,
      project: nil,
      version: 1,
      status: "MyString",
      tags: "",
      ai_assisted_design_details: ""
    ))
  end

  it "renders new pipeline form" do
    render

    assert_select "form[action=?][method=?]", pipelines_path, "post" do
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
