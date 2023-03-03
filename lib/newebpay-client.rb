# frozen_string_literal: true

require 'newebpay/config'
require 'newebpay/cancel'
require 'newebpay/version'
require 'newebpay/payment'
require 'newebpay/refund'
require 'newebpay/invoice'
require 'newebpay/response'
require 'newebpay/query_trade_info'
require 'newebpay/errors'
require 'newebpay/period/payment'
require 'newebpay/period/alter_amount'
require 'newebpay/period/alter_status'

module Newebpay
  extend Config
end
