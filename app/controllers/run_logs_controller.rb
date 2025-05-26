class RunLogsController < ApplicationController
  before_action :set_run_log, only: %i[ show edit update destroy ]

  # GET /run_logs or /run_logs.json
  def index
    @run_logs = RunLog.all
  end

  # GET /run_logs/1 or /run_logs/1.json
  def show
  end

  # GET /run_logs/new
  def new
    @run_log = RunLog.new
  end

  # GET /run_logs/1/edit
  def edit
  end

  # POST /run_logs or /run_logs.json
  def create
    @run_log = RunLog.new(run_log_params)

    respond_to do |format|
      if @run_log.save
        format.html { redirect_to @run_log, notice: "Run log was successfully created." }
        format.json { render :show, status: :created, location: @run_log }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @run_log.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /run_logs/1 or /run_logs/1.json
  def update
    respond_to do |format|
      if @run_log.update(run_log_params)
        format.html { redirect_to @run_log, notice: "Run log was successfully updated." }
        format.json { render :show, status: :ok, location: @run_log }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @run_log.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /run_logs/1 or /run_logs/1.json
  def destroy
    @run_log.destroy!

    respond_to do |format|
      format.html { redirect_to run_logs_path, status: :see_other, notice: "Run log was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_run_log
      @run_log = RunLog.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def run_log_params
      params.expect(run_log: [ :pipeline_run_id, :pipeline_step_run_id, :timestamp, :level, :message, :source ])
    end
end
