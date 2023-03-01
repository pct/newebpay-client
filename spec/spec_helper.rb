require "bundler/setup"
require "newebpay-client"

Newebpay.configure do |configure|
  configure.production_mode = 0
  configure.merchant_id = ENV.fetch('MerchantID', nil)
  configure.hash_iv = ENV.fetch('HashIV', nil)
  configure.hash_key = ENV.fetch('HashKey', nil)
  configure.version = ENV.fetch('Version', nil)
end

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
