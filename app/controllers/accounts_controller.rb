class AccountsController < ApplicationController
  before_action :set_account
  before_action :require_login

  # GET /account
  def edit
  end

  # PATCH/PUT /account
  def update
    # See if they are upgrading to Paid
    shopify_service = ShopifyIntegration.new(url: @account.shopify_account_url,
                                             password: @account.shopify_password,
                                             account_id: @account.id)

    shopify_service.connect

    if params[:account][:paid] == true || params[:account][:paid].to_i == 1
      if @account.paid?
        render 'edit'
      else
        # TODO: set the flag to false to really charge the card
        redirect_to shopify_service.create_charge(1, true)
      end
    else
      # If not, just re-render the form
      if shopify_service.delete_charge(@account.charge_id)
        puts "asdfasdfsdfasdfsdfasdfsdfsdf"
        @account.update_attribute(:paid, false)
      end

      render 'edit'
    end
  end

  private

  def set_account
    @account = current_account
  end
end
