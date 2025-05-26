require 'rails_helper'

RSpec.describe "schedules/show", type: :view do
  before(:each) do
    assign(:schedule, Schedule.create!(
      pipeline: nil,
      cron_expression: "Cron Expression",
      timezone: "Timezone",
      is_active: false,
      last_triggered_run: nil,
      created_by_user: nil
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(/Cron Expression/)
    expect(rendered).to match(/Timezone/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
  end
end
