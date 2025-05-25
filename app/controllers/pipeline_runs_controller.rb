class PipelineRunsController < ApplicationController
  before_action :set_pipeline_run, only: %i[ show edit update destroy ]

  # GET /pipeline_runs or /pipeline_runs.json
  def index
    @pipeline_runs = PipelineRun.all
  end

  # GET /pipeline_runs/1 or /pipeline_runs/1.json
  def show
  end

  # GET /pipeline_runs/new
  def new
    @pipeline_run = PipelineRun.new
  end

  # GET /pipeline_runs/1/edit
  def edit
  end

  # POST /pipeline_runs or /pipeline_runs.json
  def create
    @pipeline_run = PipelineRun.new(pipeline_run_params)

    respond_to do |format|
      if @pipeline_run.save
        format.html { redirect_to @pipeline_run, notice: "Pipeline run was successfully created." }
        format.json { render :show, status: :created, location: @pipeline_run }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @pipeline_run.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /pipeline_runs/1 or /pipeline_runs/1.json
  def update
    respond_to do |format|
      if @pipeline_run.update(pipeline_run_params)
        format.html { redirect_to @pipeline_run, notice: "Pipeline run was successfully updated." }
        format.json { render :show, status: :ok, location: @pipeline_run }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @pipeline_run.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pipeline_runs/1 or /pipeline_runs/1.json
  def destroy
    @pipeline_run.destroy!

    respond_to do |format|
      format.html { redirect_to pipeline_runs_path, status: :see_other, notice: "Pipeline run was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_pipeline_run
      @pipeline_run = PipelineRun.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def pipeline_run_params
      params.expect(pipeline_run: [ :pipeline_id, :pipeline_version_at_run, :status, :triggered_by_type, :triggered_by_user_id, :start_time, :end_time, :duration_ms, :parameters, :summary_metrics ])
    end
end
