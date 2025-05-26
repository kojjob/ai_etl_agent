require 'rails_helper'

RSpec.describe "run_logs/index", type: :view do
  before(:each) do
    assign(:run_logs, [
      RunLog.create!(
        pipeline_run: nil,
        pipeline_step_run: nil,
        level: "Level",
        message: "MyText",
        source: "Source"
      ),
      RunLog.create!(
        pipeline_run: nil,
        pipeline_step_run: nil,
        level: "Level",
        message: "MyText",
        source: "Source"
      )
    ])
  end

  it "renders a list of run_logs" do
    render
    cell_selector = 'div>p'
    assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Level".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("MyText".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Source".to_s), count: 2
  end
end
