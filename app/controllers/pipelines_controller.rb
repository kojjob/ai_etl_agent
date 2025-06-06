class PipelinesController < ApplicationController
  before_action :set_pipeline, only: %i[ show edit update destroy ]

  # GET /pipelines or /pipelines.json
  def index
    @pipelines = Pipeline.all
  end

  # GET /pipelines/1 or /pipelines/1.json
  def show
  end

  # GET /pipelines/new
  def new
    @pipeline = Pipeline.new
  end

  # GET /pipelines/1/edit
  def edit
  end

  # POST /pipelines or /pipelines.json
  def create
    @pipeline = Pipeline.new(pipeline_params)

    respond_to do |format|
      if @pipeline.save
        format.html { redirect_to @pipeline, notice: "Pipeline was successfully created." }
        format.json { render :show, status: :created, location: @pipeline }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @pipeline.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /pipelines/1 or /pipelines/1.json
  def update
    respond_to do |format|
      if @pipeline.update(pipeline_params)
        format.html { redirect_to @pipeline, notice: "Pipeline was successfully updated." }
        format.json { render :show, status: :ok, location: @pipeline }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @pipeline.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pipelines/1 or /pipelines/1.json
  def destroy
    @pipeline.destroy!

    respond_to do |format|
      format.html { redirect_to pipelines_path, status: :see_other, notice: "Pipeline was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_pipeline
      @pipeline = Pipeline.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def pipeline_params
      params.expect(pipeline: [ :name, :description, :created_by_user_id, :project_id, :version, :status, :tags, :ai_assisted_design_details ])
    end
end
