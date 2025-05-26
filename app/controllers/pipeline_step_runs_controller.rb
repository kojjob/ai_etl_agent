class PipelineStepRunsController < ApplicationController
  before_action :set_pipeline_step_run, only: %i[ show edit update destroy ]

  # GET /pipeline_step_runs or /pipeline_step_runs.json
  def index
    @pipeline_step_runs = PipelineStepRun.all
  end

  # GET /pipeline_step_runs/1 or /pipeline_step_runs/1.json
  def show
  end

  # GET /pipeline_step_runs/new
  def new
    @pipeline_step_run = PipelineStepRun.new
  end

  # GET /pipeline_step_runs/1/edit
  def edit
  end

  # POST /pipeline_step_runs or /pipeline_step_runs.json
  def create
    @pipeline_step_run = PipelineStepRun.new(pipeline_step_run_params)

    respond_to do |format|
      if @pipeline_step_run.save
        format.html { redirect_to @pipeline_step_run, notice: "Pipeline step run was successfully created." }
        format.json { render :show, status: :created, location: @pipeline_step_run }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @pipeline_step_run.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /pipeline_step_runs/1 or /pipeline_step_runs/1.json
  def update
    respond_to do |format|
      if @pipeline_step_run.update(pipeline_step_run_params)
        format.html { redirect_to @pipeline_step_run, notice: "Pipeline step run was successfully updated." }
        format.json { render :show, status: :ok, location: @pipeline_step_run }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @pipeline_step_run.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pipeline_step_runs/1 or /pipeline_step_runs/1.json
  def destroy
    @pipeline_step_run.destroy!

    respond_to do |format|
      format.html { redirect_to pipeline_step_runs_path, status: :see_other, notice: "Pipeline step run was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_pipeline_step_run
      @pipeline_step_run = PipelineStepRun.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def pipeline_step_run_params
      params.expect(pipeline_step_run: [ :pipeline_run_id, :pipeline_step_id, :status, :start_time, :end_time, :duration_ms, :metrics, :logs_summary, :input_data_preview, :output_data_preview ])
    end
end
