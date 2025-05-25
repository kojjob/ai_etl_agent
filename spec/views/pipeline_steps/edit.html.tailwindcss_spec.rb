require 'rails_helper'

RSpec.describe "pipeline_steps/edit", type: :view do
  let(:pipeline_step) {
    PipelineStep.create!(
      pipeline: nil,
      name: "MyString",
      description: "MyText",
      step_type: "MyString",
      sequence_order: 1,
      configuration: "",
      source_connection: nil,
      target_connection: nil,
      expected_input_schema: "",
      expected_output_schema: "",
      ui_position: ""
    )
  }

  before(:each) do
    assign(:pipeline_step, pipeline_step)
  end

  it "renders the edit pipeline_step form" do
    render

    assert_select "form[action=?][method=?]", pipeline_step_path(pipeline_step), "post" do

      assert_select "input[name=?]", "pipeline_step[pipeline_id]"

      assert_select "input[name=?]", "pipeline_step[name]"

      assert_select "textarea[name=?]", "pipeline_step[description]"

      assert_select "input[name=?]", "pipeline_step[step_type]"

      assert_select "input[name=?]", "pipeline_step[sequence_order]"

      assert_select "input[name=?]", "pipeline_step[configuration]"

      assert_select "input[name=?]", "pipeline_step[source_connection_id]"

      assert_select "input[name=?]", "pipeline_step[target_connection_id]"

      assert_select "input[name=?]", "pipeline_step[expected_input_schema]"

      assert_select "input[name=?]", "pipeline_step[expected_output_schema]"

      assert_select "input[name=?]", "pipeline_step[ui_position]"
    end
  end
end
