class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :destroy]

  # GET /products
  # GET /products.json
  def index
    @products = current_account.products.all
  end

  # GET /products/1
  # GET /products/1.json
  def show
  end

  # GET /products/new
  def new
    @product = current_account.products.new
  end

  # GET /products/1/edit
  def edit
  end

  # POST /products
  # POST /products.json
  def create
    @product = current_account.products.new(product_params)

    respond_to do |format|
      if @product.save
        format.html { redirect_to @product, notice: 'Product was successfully created.' }
        format.json { render action: 'show', status: :created, location: @product }
      else
        format.html { render action: 'new' }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /products/1
  # PATCH/PUT /products/1.json
  def update
    respond_to do |format|
      if @product.update(product_params)
        format.html { redirect_to @product, notice: 'Product was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /products/1
  # DELETE /products/1.json
  def destroy
    @product.destroy
    respond_to do |format|
      format.html { redirect_to products_url }
      format.json { head :no_content }
    end
  end

  # GET /products/import
  # GET /products/import.json
  def import
    # Connect to Shopify
    shopify_integration = ShopifyIntegration.new(
      url: current_account.shopify_account_url,
      password: current_account.shopify_password,
      account_id: current_account.id
    )

    respond_to do |format|
      shopify_integration.connect
      result = shopify_integration.import_products
      format.html { redirect_to ({action: :index}), notice: "#{result[:created].to_i} created, #{result[:updated]} updated, #{result[:failed]} failed." }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_product
    @product = current_account.products.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def product_params
    params.require(:product).permit(:name, :shopify_product_id, :last_shopify_sync)
  end
end
