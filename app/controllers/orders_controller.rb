class OrdersController < ApplicationController
  before_action :set_order, only: [:show, :edit, :update, :destroy]

  # GET /orders
  # GET /orders.json
  def index
    @orders = current_account.orders.all
  end

  # GET /orders/1
  # GET /orders/1.json
  def show
  end

  # GET /orders/new
  def new
    @order = current_account.orders.new
  end

  # GET /orders/1/edit
  def edit
  end

  # POST /orders
  # POST /orders.json
  def create
    @order = current_account.orders.new(order_params)

    respond_to do |format|
      if @order.save
        format.html { redirect_to @order, notice: 'Order was successfully created.' }
        format.json { render action: 'show', status: :created, location: @order }
      else
        format.html { render action: 'new' }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /orders/1
  # PATCH/PUT /orders/1.json
  def update
    respond_to do |format|
      if @order.update(order_params)
        format.html { redirect_to @order, notice: 'Order was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /orders/1
  # DELETE /orders/1.json
  def destroy
    @order.destroy
    respond_to do |format|
      format.html { redirect_to orders_url }
      format.json { head :no_content }
    end
  end

  # GET /orders/import
  # GET /orders/import.json
  def import

    # Connect to Shopify
    shopify_integration = ShopifyIntegration.new(url: current_account.shopify_account_url,
                                                 password: current_account.shopify_password,
                                                 account_id: current_account.id)

    respond_to do |format|
      if shopify_integration.connect
        # Import Products to ensure we are up to date
        shopify_integration.import_products
        result = shopify_integration.import_orders
        format.html { redirect_to ({action: :index}), notice: "#{result[:created].to_i} created, #{result[:failed]} failed." }
        format.json { render json: "#{result[:created].to_i} created, #{result[:failed]} failed." }
      else
        format.html { redirect_to ({action: :index}), alert: "Unable to connect to Shopify" }
        format.json { render json: "Unable to connect to Shopify", status: :unprocessable_entity }
      end
    end

  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_order
    @order = current_account.orders.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def order_params
    params.require(:order).permit(:number, :email, :first_name, :last_name, :shopify_order_id, :order_date, :total, :line_item_count, :financial_status)
  end
end