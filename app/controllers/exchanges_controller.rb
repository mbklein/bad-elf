class ExchangesController < ApplicationController
  before_action :set_exchange, only: [:show, :edit, :update, :destroy]
  before_action :authorize!

  # GET /exchanges
  # GET /exchanges.json
  def index
    @exchanges = ExchangeDecorator.decorate_collection(Exchange.for_user(current_user))
  end

  # GET /exchanges/1
  # GET /exchanges/1.json
  def show
  end

  # GET /exchanges/new
  def new
    @exchange = Exchange.new owner: current_user
  end

  # GET /exchanges/1/edit
  def edit
  end

  def join
    @exchange = Exchange.where(invite_code: params[:id]).first
    return redirect_to exchanges_url, notice: "Unrecognized invitiation code" if @exchange.nil?
    return redirect_to exchanges_url, notice: "This exchange is currently closed to new participants." if @exchange.closed
    notice = if @exchange.participating? current_user
      "You are already participating in '#{@exchange.name}.'"
    else
      @exchange.assignments << Assignment.create(elf: current_user)
      "You have succesfully joined '#{@exchange.name}.'"
    end
    redirect_to exchanges_url, notice: notice
  end
  
  # POST /exchanges
  # POST /exchanges.json
  def create
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
    @exchange.destroy
    respond_to do |format|
      format.html { redirect_to exchanges_url, notice: 'Exchange was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def authorize!
      authorized = case params['action']
      when 'index'
        true
      when 'show'
        @exchange.participating?(current_user) or current_user == @exchange.owner
      when 'new', 'create', 'join'
        current_user.present?
      when 'edit', 'update', 'destroy'
        current_user == @exchange.owner
      end
      redirect_to exchanges_url, notice: I18n.t("exchange.auth.#{params['action']}") unless authorized
      authorized
    end
    
    # Use callbacks to share common setup or constraints between actions.
    def set_exchange
      @exchange = ExchangeDecorator.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def exchange_params
      params.require(:exchange).permit(:name, :description, :deadline, :closed)
    end
end
