class ShopifyController < ApplicationController

  # Skip the login requirement
  skip_before_filter :require_login
  skip_before_filter :verify_authenticity_token


  def authorize

    unless params[:shop].present?
      render :text => ":shop parameter required" and return
    end

    # Redirect to the authorization page
    redirect_to "https://#{params[:shop].gsub(".myshopify.com","")}.myshopify.com/admin/oauth/authorize?client_id=#{SHOPIFY_API_KEY}&scope=read_products,read_orders,read_customers"

  end

  def install

    if ShopifyIntegration.verify(params)

      # Initialize the connection to Shopify
      http = Net::HTTP.new(params[:shop], 443)
      http.use_ssl = true
      path = '/admin/oauth/access_token'

      # Include the relevant pieces of information
      data = {
        'client_id' => SHOPIFY_API_KEY,
        'client_secret' => SHOPIFY_SHARED_SECRET,
        'code' => params[:code]
      }

      # POST to Shopify in order to receive the permanent token
      response = http.post(path, data.to_query, headers)
      result = ActiveSupport::JSON.decode(response.body)

      # See if the Account already exists
      account = Account.find_by_shopify_account_url(params[:shop])

      # Update the existing Account if so
      if account.present?
        account.update_attributes(shopify_password: result["access_token"])
      else # Create a new account
        account = Account.create(shopify_shop_name: params[:shop], shopify_password: result["access_token"], shopify_account_url: params[:shop])
      end

      # Reload to ensure we get the proper value for ID
      account.reload

      # Set this account as the active one
      login(account.id)

      # Use our new credentials to grab account information
      shopify_service = ShopifyIntegration.new(url: account.shopify_account_url, password: account.shopify_password, account_id: account.id)
      shopify_service.connect
      shopify_service.update_account
      shopify_service.setup_webhooks

      # Redirect to the dashboard
      redirect_to dashboard_index_path

    else
      render :text => "Unable to verify request"
    end

  end

  def confirm
    # Retrieve the Account related to the charge
    account = Account.find_by_charge_id(params[:charge_id].to_i)

    # Retrieve the ApplicationCharge
    charge = ShopifyAPI::RecurringApplicationCharge.find(params[:charge_id].to_i)

    # If it's been accepted, activate it and update the account
    if charge.status == "accepted"
      charge.activate
      account.update_attribute(:paid, true)
      message = "Your account has been updated!"
    else
      # If the payment has been denied, then mark the account as unpaid
      account.update_attribute(:paid, false)
      message = "Oops! Looks like the charge didn't go through.  Please try again."

    end
    redirect_to account_path, notice: message and return
  end
end
