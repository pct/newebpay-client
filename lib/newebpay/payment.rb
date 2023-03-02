# frozen_string_literal: true

require_relative 'config'
require_relative 'errors'
require_relative './AES/cryptographic'
require_relative './SHA256/cryptographic'

module Newebpay
  class Payment
    attr_accessor :trade_info

    def initialize(order_number: nil, amount: nil, product_description: '產品說明', email: '', order_comment: '')
      unless order_number && amount
        raise Newebpay::PaymentArgumentError,
              'Please make sure that your arguments (order_number, amount) are filled in correctly'
      end

      @key = Config.options[:HashKey]
      @iv = Config.options[:HashIV]

      @order_number = order_number
      @order_comment = order_comment
      @amount = amount
      @email = email
      @product_description = product_description

      set_trade_info

      @aes_trade_info = AES::Cryptographic.new(url_encoded_trade_info).encrypt
      @sha256_trade_info = SHA256::Cryptographic.new(@aes_trade_info).encrypt
    end

    def required_parameters
      {
        MerchantID: Config.options[:MerchantID], # 商店 ID
        TradeInfo: @aes_trade_info, # AES 加密過的 trade info
        TradeSha: @sha256_trade_info, # sha256 加密過的 trade info
        Version: Config.options[:Version] # 藍新金流版本號
      }
    end

    private

    def url_encoded_trade_info
      URI.encode_www_form(@trade_info)
    end

    def set_trade_info
      options = Config.options.except(:HashKey, :HashIV)
      @trade_info = options.transform_keys(&:to_sym)

      individual_trade_info = {
        MerchantOrderNo: @order_number, # 商店訂單編號，如：用途_日期時間戳記_流水號
        Amt: @amount.to_i, # 訂單金額
        ItemDesc: @product_description, # 商品資訊 (50 字內)
        TimeStamp: Time.now.to_i.to_s,
        OrderComment: @order_comment, # 商店備註 (300字內，亦會在藍新頁面出現)
        Email: @email # 用戶的 Email
      }

      @trade_info.merge!(individual_trade_info)
    end
  end
end
