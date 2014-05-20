class SessionsController < ApplicationController
  skip_before_action :require_login
  skip_before_filter :verify_authenticity_token

  def new
    # Nothing to do, this will simply render the view
  end

  def create
    if Rails.env.development? || Rails.env.test?
      # For development it's simplest to load the first Account
      # because Shopify does not allow us to use our local machine
      # for authorize / install requests
      session[:current_account_id] = params[:account_id]
      redirect_to dashboard_index_path
    end
  end

  def destroy
    # Send them back to Shopify
    if current_account
      redirect_to "https://#{current_account.shopify_account_url}/admin/apps"
    else
      redirect_to sessions_new_path
    end

    # Log the user out by clearing the session and global variables.
    session[:current_account_id] = @_current_account = nil
  end
end
