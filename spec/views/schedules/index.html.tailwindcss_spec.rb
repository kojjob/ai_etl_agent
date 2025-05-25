require 'rails_helper'

RSpec.describe "schedules/index", type: :view do
  before(:each) do
    assign(:schedules, [
      Schedule.create!(
        pipeline: nil,
        cron_expression: "Cron Expression",
        timezone: "Timezone",
        is_active: false,
        last_triggered_run: nil,
        created_by_user: nil
      ),
      Schedule.create!(
        pipeline: nil,
        cron_expression: "Cron Expression",
        timezone: "Timezone",
        is_active: false,
        last_triggered_run: nil,
        created_by_user: nil
      )
    ])
  end

  it "renders a list of schedules" do
    render
    cell_selector = 'div>p'
    assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Cron Expression".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Timezone".to_s), count: 2
    assert_select cell_selector, text: Regexp.new(false.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
  end
end
