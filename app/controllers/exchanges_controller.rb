class ExchangesController < ApplicationController
  before_action :set_exchange, only: [:show, :edit, :update, :destroy, :shuffle]

  rescue_from CanCan::AccessDenied do |exception|
    redirect_path = [:new, :create, :join].include?(exception.action) ? signin_url(return_path: request.path) : exchanges_url
    redirect_to redirect_path, :alert => I18n.t("exchange.auth.#{exception.action}")
  end

  # GET /exchanges
  # GET /exchanges.json
  def index
    visible = if current_user.nil?
      Exchange.none
    elsif current_user.admin?
      Exchange.all
    else
      Exchange.for_user(current_user)
    end
    @exchanges = ExchangeDecorator.decorate_collection(visible)
  end

  # GET /exchanges/1
  # GET /exchanges/1.json
  def show
    authorize! :show, @exchange
  end

  # GET /exchanges/new
  def new
    authorize! :create, Exchange
    @exchange = Exchange.new owner: current_user
  end

  # GET /exchanges/1/edit
  def edit
    authorize! :update, @exchange
  end

  def join
    @exchange = Exchange.where(invite_code: params[:id]).first.decorate rescue nil
    authorize! :join, @exchange
    if params[:confirm]
      return redirect_to exchanges_url, notice: "Unrecognized invitiation code" if @exchange.nil?
      return redirect_to exchanges_url, notice: "This exchange is currently closed to new participants." if @exchange.closed
      notice = if @exchange.participating? current_user
        "You are already participating in '#{@exchange.name}.'"
      else
        @exchange.assignments << Assignment.create(elf: current_user)
        "You have succesfully joined '#{@exchange.name}.'"
      end
      redirect_to exchanges_url, notice: notice
    else
      render
    end
  end

  # POST /exchanges
  # POST /exchanges.json
  def create
    authorize! :create, Exchange
    @exchange = Exchange.new(exchange_params)
    @exchange.owner = current_user

    respond_to do |format|
      if @exchange.save
        format.html { redirect_to exchanges_url, notice: 'Exchange was successfully created.' }
        format.json { render :show, status: :created, location: @exchange }
      else
        format.html { render :new }
        format.json { render json: @exchange.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /exchanges/1
  # PATCH/PUT /exchanges/1.json
  def update
    authorize! :update, @exchange
    respond_to do |format|
      if @exchange.update(exchange_params)
        format.html { redirect_to exchanges_url, notice: 'Exchange was successfully updated.' }
        format.json { render :show, status: :ok, location: @exchange }
      else
        format.html { render :edit }
        format.json { render json: @exchange.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /exchanges/1
  # DELETE /exchanges/1.json
  def destroy
    authorize! :destroy, @exchange
    @exchange.destroy
    respond_to do |format|
      format.html { redirect_to exchanges_url, notice: 'Exchange was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def shuffle
    authorize! :update, @exchange
    @exchange.shuffle!
    respond_to do |format|
      format.html { redirect_to exchange_url(@exchange), notice: 'Exchange was successfully shuffled.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_exchange
      @exchange = ExchangeDecorator.find(params[:id])
      @display_title = @exchange.name if @exchange.present?
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def exchange_params
      params.require(:exchange).permit(:name, :description, :deadline, :closed)
    end
end
