require 'rails_helper'

RSpec.describe "run_logs/show", type: :view do
  before(:each) do
    assign(:run_log, RunLog.create!(
      pipeline_run: nil,
      pipeline_step_run: nil,
      level: "Level",
      message: "MyText",
      source: "Source"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(/Level/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/Source/)
  end
end
