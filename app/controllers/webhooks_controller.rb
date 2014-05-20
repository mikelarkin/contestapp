class WebhooksController < ApplicationController
  def uninstall

    # Pull the account information from the Header X-Shopify-Shop-Domain
    if request.headers['HTTP_X_SHOPIFY_SHOP_DOMAIN'].present?
      @account = Account.find_by_shopify_url(request.headers['HTTP_X_SHOPIFY_SHOP_DOMAIN'])
    else
      # TODO: decide what to do for unrecognized webhooks.  Ignore for now
      render :text => "Unknown account", status: 200 and return
    end

    # Be kind, rewind
    request.body.rewind
    webhook_service = WebhookService.new(request, @account)

    if webhook_service.verify_webhook
      result = webhook_service.process_uninstall
      if result
        head :ok
      else
        # TODO handle invalid orders
        render :text => "Unable to remove account", status: 200
      end
    else
      # TODO handle fradualent webhooks
      render :text => "Signature did not match, possibly fradualent!", status: 200
    end
  end
end
