class AiInteractionLogsController < ApplicationController
  before_action :set_ai_interaction_log, only: %i[ show edit update destroy ]

  # GET /ai_interaction_logs or /ai_interaction_logs.json
  def index
    @ai_interaction_logs = AiInteractionLog.all
  end

  # GET /ai_interaction_logs/1 or /ai_interaction_logs/1.json
  def show
  end

  # GET /ai_interaction_logs/new
  def new
    @ai_interaction_log = AiInteractionLog.new
  end

  # GET /ai_interaction_logs/1/edit
  def edit
  end

  # POST /ai_interaction_logs or /ai_interaction_logs.json
  def create
    @ai_interaction_log = AiInteractionLog.new(ai_interaction_log_params)

    respond_to do |format|
      if @ai_interaction_log.save
        format.html { redirect_to @ai_interaction_log, notice: "Ai interaction log was successfully created." }
        format.json { render :show, status: :created, location: @ai_interaction_log }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @ai_interaction_log.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /ai_interaction_logs/1 or /ai_interaction_logs/1.json
  def update
    respond_to do |format|
      if @ai_interaction_log.update(ai_interaction_log_params)
        format.html { redirect_to @ai_interaction_log, notice: "Ai interaction log was successfully updated." }
        format.json { render :show, status: :ok, location: @ai_interaction_log }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @ai_interaction_log.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /ai_interaction_logs/1 or /ai_interaction_logs/1.json
  def destroy
    @ai_interaction_log.destroy!

    respond_to do |format|
      format.html { redirect_to ai_interaction_logs_path, status: :see_other, notice: "Ai interaction log was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ai_interaction_log
      @ai_interaction_log = AiInteractionLog.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def ai_interaction_log_params
      params.expect(ai_interaction_log: [ :user_id, :session_id, :user_query, :ai_response, :interaction_type, :context_entity_id, :context_entity_type ])
    end
end
