require 'rails_helper'

RSpec.describe "ai_suggestions/index", type: :view do
  before(:each) do
    assign(:ai_suggestions, [
      AiSuggestion.create!(
        user: nil,
        session_id: "",
        context_entity: nil,
        suggestion_prompt: "MyText",
        suggestion_content: "",
        suggestion_type: "Suggestion Type",
        confidence_score: 2.5,
        status: "Status",
        feedback_rating: 3,
        feedback_text: "MyText"
      ),
      AiSuggestion.create!(
        user: nil,
        session_id: "",
        context_entity: nil,
        suggestion_prompt: "MyText",
        suggestion_content: "",
        suggestion_type: "Suggestion Type",
        confidence_score: 2.5,
        status: "Status",
        feedback_rating: 3,
        feedback_text: "MyText"
      )
    ])
  end

  it "renders a list of ai_suggestions" do
    render
    cell_selector = 'div>p'
    assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
    assert_select cell_selector, text: Regexp.new("".to_s), count: 2
    assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
    assert_select cell_selector, text: Regexp.new("MyText".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Suggestion Type".to_s), count: 2
    assert_select cell_selector, text: Regexp.new(2.5.to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Status".to_s), count: 2
    assert_select cell_selector, text: Regexp.new(3.to_s), count: 2
    assert_select cell_selector, text: Regexp.new("MyText".to_s), count: 2
  end
end
