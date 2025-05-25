class DashboardWidgetsController < ApplicationController
  before_action :set_dashboard_widget, only: %i[ show edit update destroy ]

  # GET /dashboard_widgets or /dashboard_widgets.json
  def index
    @dashboard_widgets = DashboardWidget.all
  end

  # GET /dashboard_widgets/1 or /dashboard_widgets/1.json
  def show
  end

  # GET /dashboard_widgets/new
  def new
    @dashboard_widget = DashboardWidget.new
  end

  # GET /dashboard_widgets/1/edit
  def edit
  end

  # POST /dashboard_widgets or /dashboard_widgets.json
  def create
    @dashboard_widget = DashboardWidget.new(dashboard_widget_params)

    respond_to do |format|
      if @dashboard_widget.save
        format.html { redirect_to @dashboard_widget, notice: "Dashboard widget was successfully created." }
        format.json { render :show, status: :created, location: @dashboard_widget }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @dashboard_widget.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /dashboard_widgets/1 or /dashboard_widgets/1.json
  def update
    respond_to do |format|
      if @dashboard_widget.update(dashboard_widget_params)
        format.html { redirect_to @dashboard_widget, notice: "Dashboard widget was successfully updated." }
        format.json { render :show, status: :ok, location: @dashboard_widget }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @dashboard_widget.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /dashboard_widgets/1 or /dashboard_widgets/1.json
  def destroy
    @dashboard_widget.destroy!

    respond_to do |format|
      format.html { redirect_to dashboard_widgets_path, status: :see_other, notice: "Dashboard widget was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_dashboard_widget
      @dashboard_widget = DashboardWidget.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def dashboard_widget_params
      params.expect(dashboard_widget: [ :dashboard_id, :widget_type, :title, :configuration, :refresh_interval_seconds ])
    end
end
