class WebhookService

  attr_accessor :request, :account

  def initialize(request, account)
    @request = request
    @account = account
  end

  # This method is provided by Shopify on their Wiki
  def verify_webhook

    # TODO: disable this after launch
    return true if @request.headers['HTTP_X_SHOPIFY_TEST'].to_s == "true"

    # Make sure the encrypted header was passed in
    hmac_header = @request.headers['HTTP_X_SHOPIFY_HMAC_SHA256']
    return false if hmac_header.blank?

    # In order to verify the authenticity of the request
    # We need to compare the header hmac to one
    # We compute on the fly
    data = @request.body.read.to_s

    # Calculate the hmac using our shared secret and the request body
    digest = OpenSSL::Digest::Digest.new('sha256')
    calculated_hmac = Base64.encode64(OpenSSL::HMAC.digest(digest, SHOPIFY_SHARED_SECRET, data)).strip

    unless calculated_hmac == hmac_header
      return false
    end

    # Rewind the request body so that Rails can reprocess it
    @request.body.rewind
    return true

  end

  def process_uninstall

    # This is a simple one.
    # Due to dependencies, ActiveRecord will automatically
    # Remove the related Orders, Products, and Contests
    return @account.destroy

  end

end
