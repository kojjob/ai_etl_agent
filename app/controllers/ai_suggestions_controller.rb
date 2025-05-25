class AiSuggestionsController < ApplicationController
  before_action :set_ai_suggestion, only: %i[ show edit update destroy ]

  # GET /ai_suggestions or /ai_suggestions.json
  def index
    @ai_suggestions = AiSuggestion.all
  end

  # GET /ai_suggestions/1 or /ai_suggestions/1.json
  def show
  end

  # GET /ai_suggestions/new
  def new
    @ai_suggestion = AiSuggestion.new
  end

  # GET /ai_suggestions/1/edit
  def edit
  end

  # POST /ai_suggestions or /ai_suggestions.json
  def create
    @ai_suggestion = AiSuggestion.new(ai_suggestion_params)

    respond_to do |format|
      if @ai_suggestion.save
        format.html { redirect_to @ai_suggestion, notice: "Ai suggestion was successfully created." }
        format.json { render :show, status: :created, location: @ai_suggestion }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @ai_suggestion.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /ai_suggestions/1 or /ai_suggestions/1.json
  def update
    respond_to do |format|
      if @ai_suggestion.update(ai_suggestion_params)
        format.html { redirect_to @ai_suggestion, notice: "Ai suggestion was successfully updated." }
        format.json { render :show, status: :ok, location: @ai_suggestion }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @ai_suggestion.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /ai_suggestions/1 or /ai_suggestions/1.json
  def destroy
    @ai_suggestion.destroy!

    respond_to do |format|
      format.html { redirect_to ai_suggestions_path, status: :see_other, notice: "Ai suggestion was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ai_suggestion
      @ai_suggestion = AiSuggestion.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def ai_suggestion_params
      params.expect(ai_suggestion: [ :user_id, :session_id, :context_entity_id, :context_entity_type, :suggestion_prompt, :suggestion_content, :suggestion_type, :confidence_score, :status, :feedback_rating, :feedback_text ])
    end
end
