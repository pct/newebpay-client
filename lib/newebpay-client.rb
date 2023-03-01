# frozen_string_literal: true

require 'newebpay/config'
require 'newebpay/version'
require 'newebpay/payment'
require 'newebpay/refund'
require 'newebpay/invoice'
require 'newebpay/response'
require 'newebpay/errors'

module Newebpay
  extend Config

  def api_base_url
    self.production_mode ||= 0
    self.production_mode == 0 ? "https://ccore.newebpay.com" : "https://core.newebpay.com"
  end
end
