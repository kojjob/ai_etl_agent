class AlertRulesController < ApplicationController
  before_action :set_alert_rule, only: %i[ show edit update destroy ]

  # GET /alert_rules or /alert_rules.json
  def index
    @alert_rules = AlertRule.all
  end

  # GET /alert_rules/1 or /alert_rules/1.json
  def show
  end

  # GET /alert_rules/new
  def new
    @alert_rule = AlertRule.new
  end

  # GET /alert_rules/1/edit
  def edit
  end

  # POST /alert_rules or /alert_rules.json
  def create
    @alert_rule = AlertRule.new(alert_rule_params)

    respond_to do |format|
      if @alert_rule.save
        format.html { redirect_to @alert_rule, notice: "Alert rule was successfully created." }
        format.json { render :show, status: :created, location: @alert_rule }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @alert_rule.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /alert_rules/1 or /alert_rules/1.json
  def update
    respond_to do |format|
      if @alert_rule.update(alert_rule_params)
        format.html { redirect_to @alert_rule, notice: "Alert rule was successfully updated." }
        format.json { render :show, status: :ok, location: @alert_rule }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @alert_rule.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /alert_rules/1 or /alert_rules/1.json
  def destroy
    @alert_rule.destroy!

    respond_to do |format|
      format.html { redirect_to alert_rules_path, status: :see_other, notice: "Alert rule was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_alert_rule
      @alert_rule = AlertRule.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def alert_rule_params
      params.expect(alert_rule: [ :name, :description, :target_entity_type, :condition, :severity, :notification_channels, :is_active ])
    end
end
