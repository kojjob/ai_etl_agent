require 'rails_helper'

RSpec.describe "ai_suggestions/show", type: :view do
  before(:each) do
    assign(:ai_suggestion, AiSuggestion.create!(
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
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(//)
    expect(rendered).to match(/Suggestion Type/)
    expect(rendered).to match(/2.5/)
    expect(rendered).to match(/Status/)
    expect(rendered).to match(/3/)
    expect(rendered).to match(/MyText/)
  end
end
