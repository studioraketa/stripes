module Stripes
  Configuration.configure do |config|
    config.order_class = ::Order
    config.order_table_foreign_key = :order_id
    config.http_basic_auth_user = 'user'
    config.http_basic_auth_password = 'secret'
    config.stripe_webhook_secret = 'whsec_random-secret'
    config.stripe_public_key = 'does-not-matter-for-automated-testing'
    config.stripe_private_key = 'does-not-matter-for-automated-testing'
  end
end
