require 'rails_helper'

RSpec.describe "ai_interaction_logs/index", type: :view do
  before(:each) do
    assign(:ai_interaction_logs, [
      AiInteractionLog.create!(
        user: nil,
        session_id: "",
        user_query: "MyText",
        ai_response: "MyText",
        interaction_type: "Interaction Type",
        context_entity: nil
      ),
      AiInteractionLog.create!(
        user: nil,
        session_id: "",
        user_query: "MyText",
        ai_response: "MyText",
        interaction_type: "Interaction Type",
        context_entity: nil
      )
    ])
  end

  it "renders a list of ai_interaction_logs" do
    render
    cell_selector = 'div>p'
    assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
    assert_select cell_selector, text: Regexp.new("".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("MyText".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("MyText".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Interaction Type".to_s), count: 2
    assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
  end
end
