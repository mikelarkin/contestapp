class VariantsController < ApplicationController
  before_action :set_product
  before_action :set_variant, only: [:show, :edit, :update, :destroy]

  # GET /variants
  # GET /variants.json
  def index
    @variants = Variant.all
  end

  # GET /variants/1
  # GET /variants/1.json
  def show
  end

  # GET /variants/new
  def new
    @variant = Variant.new
  end

  # GET /variants/1/edit
  def edit
  end

  # POST /variants
  # POST /variants.json
  def create
    @variant = Variant.new(variant_params)

    respond_to do |format|
      if @variant.save
        format.html { redirect_to @variant, notice: 'Variant was successfully created.' }
        format.json { render action: 'show', status: :created, location: @variant }
      else
        format.html { render action: 'new' }
        format.json { render json: @variant.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /variants/1
  # PATCH/PUT /variants/1.json
  def update
    respond_to do |format|
      if @variant.update(variant_params)
        format.html { redirect_to @variant, notice: 'Variant was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @variant.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /variants/1
  # DELETE /variants/1.json
  def destroy
    @variant.destroy
    respond_to do |format|
      format.html { redirect_to variants_url }
      format.json { head :no_content }
    end
  end

  private

  def set_product
    @product = Product.find(params[:product_id])
  end
  # Use callbacks to share common setup or constraints between actions.
  def set_variant
    @variant = @product.variants.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def variant_params
    params.require(:variant).permit(:product_id, :shopify_variant_id, :option1, :option2, :option3, :sku, :barcode, :price, :last_shopify_sync)
  end
end
