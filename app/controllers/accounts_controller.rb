class AccountsController < ApplicationController
  before_action :set_account, only: [:show, :edit, :update, :destroy, :test_connection]

  # GET /accounts
  # GET /accounts.json
  def index
    @accounts = Account.all
  end

  # GET /accounts/1
  # GET /accounts/1.json
  def show
  end

  # GET /accounts/new
  def new
    @account = Account.new
  end

  # GET /accounts/1/edit
  def edit
  end

  # POST /accounts
  # POST /accounts.json
  def create
    @account = Account.new(account_params)

    respond_to do |format|
      if @account.save
        format.html { redirect_to @account, notice: 'Account was successfully created.' }
        format.json { render action: 'show', status: :created, location: @account }
      else
        format.html { render action: 'new' }
        format.json { render json: @account.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /accounts/1
  # PATCH/PUT /accounts/1.json
  def update
    respond_to do |format|
      if @account.update(account_params)
        format.html { redirect_to @account, notice: 'Account was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @account.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /accounts/1
  # DELETE /accounts/1.json
  def destroy
    @account.destroy
    respond_to do |format|
      format.html { redirect_to accounts_url }
      format.json { head :no_content }
    end
  end

  # GET /accounts/1/test_connection
  # GET /accounts/1/test_connection.json
  def test_connection
    # Connect to Shopify using our class
    ShopifyIntegration.new(api_key: @account.shopify_api_key,
                           shared_secret: @account.shopify_shared_secret,
                           url: @account.shopify_account_url,
                           password: @account.shopify_password).connect()
    begin
      # The gem will throw an exception if unable to retrieve Shop information
      shop = ShopifyAPI::Shop.current
    rescue => ex
      @message = ex.message
    end

    if shop.present?
      respond_to do |format|
        # Report the good news
        format.html { redirect_to @account, notice: "Successfully Connected to #{shop.name}" }
        format.json { render json: "Successfully Connected to #{shop.name}" }
      end
    else
      respond_to do |format|
        # Return the message from the exception
        format.html { redirect_to @account, alert: "Unable to Connect: #{@message}" }
        format.json { render json: "Unable to Connect: #{@message}", status: :unprocessable_entity }
      end
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_account
    @account = Account.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def account_params
    params.require(:account).permit(:shopify_account_url, :shopify_api_key, :shopify_password, :shopify_shared_secret)
  end
end