class PipelineStepsController < ApplicationController
  before_action :set_pipeline_step, only: %i[ show edit update destroy ]

  # GET /pipeline_steps or /pipeline_steps.json
  def index
    @pipeline_steps = PipelineStep.all
  end

  # GET /pipeline_steps/1 or /pipeline_steps/1.json
  def show
  end

  # GET /pipeline_steps/new
  def new
    @pipeline_step = PipelineStep.new
  end

  # GET /pipeline_steps/1/edit
  def edit
  end

  # POST /pipeline_steps or /pipeline_steps.json
  def create
    @pipeline_step = PipelineStep.new(pipeline_step_params)

    respond_to do |format|
      if @pipeline_step.save
        format.html { redirect_to @pipeline_step, notice: "Pipeline step was successfully created." }
        format.json { render :show, status: :created, location: @pipeline_step }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @pipeline_step.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /pipeline_steps/1 or /pipeline_steps/1.json
  def update
    respond_to do |format|
      if @pipeline_step.update(pipeline_step_params)
        format.html { redirect_to @pipeline_step, notice: "Pipeline step was successfully updated." }
        format.json { render :show, status: :ok, location: @pipeline_step }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @pipeline_step.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pipeline_steps/1 or /pipeline_steps/1.json
  def destroy
    @pipeline_step.destroy!

    respond_to do |format|
      format.html { redirect_to pipeline_steps_path, status: :see_other, notice: "Pipeline step was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_pipeline_step
      @pipeline_step = PipelineStep.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def pipeline_step_params
      params.expect(pipeline_step: [ :pipeline_id, :name, :description, :step_type, :sequence_order, :configuration, :source_connection_id, :target_connection_id, :expected_input_schema, :expected_output_schema, :ui_position ])
    end
end
