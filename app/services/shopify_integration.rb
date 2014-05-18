class ShopifyIntegration

  attr_accessor :api_key, :shared_secret, :url, :password

  def initialize(params)
    # Ensure that all the parameters are passed in
    %w{api_key shared_secret url password}.each do |field|
      raise ArgumentError.new("params[:#{field}] is required") if params[field.to_sym].blank?

      # If present, then set as an instance variable
      instance_variable_set("@#{field}", params[field.to_sym])
    end
  end

  # Uses the provided credentials to create an active Shopify session
  def connect

    # Initialize the gem
    ShopifyAPI::Session.setup({api_key: @api_key, secret: @shared_secret})

    # Instantiate the session
    session = ShopifyAPI::Session.new(@url, @password)

    # Activate the Session so that requests can be made
    return ShopifyAPI::Base.activate_session(session)

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
                            financial_status: shopify_order.financial_status
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
          product = Product.new(last_shopify_sync: DateTime.now, name: shopify_product.title, shopify_product_id: shopify_product.id)
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

end