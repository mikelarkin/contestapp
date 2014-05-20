class ShopifyIntegration

  attr_accessor :url, :password, :account_id

  def initialize(params)
    # Ensure that all the parameters are passed in
    %w{url password account_id}.each do |field|
      raise ArgumentError.new("params[:#{field}] is required") if params[field.to_sym].blank?

      # If present, then set as an instance variable
      instance_variable_set("@#{field}", params[field.to_sym])
    end
  end

  # Uses the provided credentials to create an active Shopify session
  def connect

    # Initialize the gem
    ShopifyAPI::Session.setup({api_key: SHOPIFY_API_KEY, secret: SHOPIFY_SHARED_SECRET})

    # Instantiate the session
    session = ShopifyAPI::Session.new(@url, @password)

    # Activate the Session so that requests can be made
    return ShopifyAPI::Base.activate_session(session)

  end

  def update_account

    # This method grabs the ShopifyAPI::Shop information
    # and updates the local record

    shop = ShopifyAPI::Shop.current

    # Map the shop fields to our local model
    # Choosing clarity over cleverness
    account = Account.find @account_id

    account.shopify_shop_id = shop.id
    account.shopify_shop_name = shop.name
    account.shop_owner = shop.shop_owner
    account.email = shop.email

    account.save


  end

  def import_orders

    # Local variables
    created = failed = 0
    page = 1


    # Get the first page of orders
    shopify_orders = ShopifyAPI::Order.find(:all, params: {limit: 50, page: page})

    # Keep going while we have more orders to process
    while shopify_orders.size > 0

      shopify_orders.each do |shopify_order|

        # See if we've already imported the order
        order = Order.find_by_shopify_order_id(shopify_order.id)

        unless order.present?

          # If not already imported, create a new order
          order = Order.new(number: shopify_order.name,
                            email: shopify_order.email,
                            first_name: shopify_order.billing_address.first_name,
                            last_name: shopify_order.billing_address.last_name,
                            shopify_order_id: shopify_order.id,
                            order_date: shopify_order.created_at,
                            total: shopify_order.total_price,
                            financial_status: shopify_order.financial_status,
                            account_id: @account_id
                            )

          # Iterate through the line_items
          shopify_order.line_items.each do |line_item|
            variant = Variant.find_by_shopify_variant_id(line_item.variant_id)
            if variant.present?
              order.order_items.build(variant_id: variant.id,
                                      shopify_product_id: line_item.product_id,
                                      shopify_variant_id: line_item.id,
                                      quantity:  line_item.quantity,
                                      unit_price: line_item.price)
            end
          end

          if order.save
            created += 1
          else
            failed += 1
          end
        end

      end

      # Grab the next page of products
      page += 1
      shopify_orders = ShopifyAPI::Order.find(:all, params: {limit: 50, page: page})


    end

    # Once we are done, return the results
    return {created: created,  failed: failed}
  end

  def import_products

    # Local variables
    created = failed = updated = 0
    page = 1

    # Grab the first page of products
    shopify_products = ShopifyAPI::Product.find(:all, params: {limit: 100, page: page})

    # Keep looping until no more products are returned
    while shopify_products.size > 0

      shopify_products.each do |shopify_product|

        # See if the product exists
        product = Product.find_by_shopify_product_id(shopify_product.id)

        # If so, attempt to update it
        if product.present?
          unless product.update_attributes(last_shopify_sync: DateTime.now, name: shopify_product.title)
            failed += 1
            next
          end
        else

          # Otherwise, create it
          product = Product.new(last_shopify_sync: DateTime.now,
                                name: shopify_product.title,
                                shopify_product_id: shopify_product.id,
                                account_id: @account_id
                                )
          unless product.save
            failed += 1
            next
          end
        end

        # Iterate through the variants
        shopify_product.variants.each do |shopify_variant|

          # See if the variant exists
          variant = Variant.find_by_shopify_variant_id(shopify_variant.id)
          if variant.present?
            # If so, update it
            if variant.update_attributes(sku: shopify_variant.sku, barcode: shopify_variant.barcode, option1: shopify_variant.option1, option2: shopify_variant.option2, option3: shopify_variant.option3, product_id: product.id, shopify_variant_id: shopify_variant.id, price: shopify_variant.price, last_shopify_sync: DateTime.now)
              updated += 1
            else
              failed += 1
            end
          else
            # Otherwise create it
            if Variant.create(sku: shopify_variant.sku, barcode: shopify_variant.barcode, option1: shopify_variant.option1, option2: shopify_variant.option2, option3: shopify_variant.option3, product_id: product.id, shopify_variant_id: shopify_variant.id, price: shopify_variant.price, last_shopify_sync: DateTime.now)
              created += 1
            else
              failed += 1
            end
          end
        end

      end

      # Grab the next page of products
      page += 1
      shopify_products = ShopifyAPI::Product.find(:all, params: {limit: 100, page: page})


    end

    # Return the results once no more products are left
    return {created: created, updated: updated, failed: failed}

  end

  def setup_webhooks

    webhook_url = "#{DOMAIN}/webhooks/uninstall"

    begin

      # Remove any existing webhooks
      webhooks = ShopifyAPI::Webhook.find :all
      webhooks.each do |webhook|
        webhook.destroy if webhook.address.include?(DOMAIN)
      end

      # Setup our webhook
      ShopifyAPI::Webhook.create(address: webhook_url, topic: "app/uninstalled", format: "json")

    rescue => ex
      puts "---------------"
      puts ex.message
    end

  end


  # This method is used to verify Shopify requests / redirects
  def self.verify(params)

    hash = params.slice(:code, :shop, :signature, :timestamp)

    received_signature = hash.delete(:signature)

    # Collect the URL parameters into an array of elements of the format "#{parameter_name}=#{parameter_value}"
    calculated_signature = hash.collect { |k, v| "#{k}=#{v}" } # => ["shop=some-shop.myshopify.com", "timestamp=1337178173", "code=a94a110d86d2452eb3e2af4cfb8a3828"]

    # Sort the key/value pairs in the array
    calculated_signature = calculated_signature.sort # => ["code=25e725143c2faf592f454f2949c8e4e2", "shop=some-shop.myshopify.com", "timestamp=1337178173

    # Join the array elements into a string
    calculated_signature = calculated_signature.join # => "code=a94a110d86d2452eb3e2af4cfb8a3828shop=some-shop.myshopify.comtimestamp=1337178173"

    # Final calculated_signature to compare against
    calculated_signature = Digest::MD5.hexdigest(SHOPIFY_SHARED_SECRET + calculated_signature) # => "25e725143c2faf592f454f2949c8e4e2"

    return calculated_signature == received_signature
  end

end