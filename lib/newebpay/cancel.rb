# frozen_string_literal: true

require_relative 'config'
require_relative 'errors'
require_relative './AES/cryptographic'
require_relative './SHA256/cryptographic'

module Newebpay
  class Cancel
    attr_accessor :trade_info
    attr_reader :response

    def initialize(
      order_number: nil,
      amount: nil
    )
      unless order_number && amount
        raise Newebpay::PaymentArgumentError,
          '請確認以下參數皆有填寫:
          - order_number
          - amount
          '
      end

      @key = Config.options[:HashKey]
      @iv = Config.options[:HashIV]

      @order_number = order_number
      @amount = amount

      set_trade_info
      set_post_data
    end

    def request!
      uri = URI("#{self.api_base_url}/API/CreditCard/Cancel")
      res = Net::HTTP.post_form(uri, MerchantID_: Config.options[:MerchantID], PostData_: @post_data)
      @response = JSON.parse(res.body)
    end

    def success?
      return if @response.nil?

      @response['Status'] == 'SUCCESS'
    end

    private

    def set_trade_info
      @trade_info = {
        RespondType: 'JSON',
        Version: '1.0',
        MerchantOrderNo: @order_number,
        Amt: @amount.to_i,
        TimeStamp: Time.now.to_i.to_s,
        IndexType: 1, # 使用 MerchantOrderNo 判斷，不用 TradeNo
        #TradeNo: nil, # 藍新金流交易序號，只要有填 MerchantOrderNo 就不用填這欄
      }
    end

    def set_post_data
      url_encoded_trade_info = URI.encode_www_form(@trade_info)
      @post_data = AES::Cryptographic.new(url_encoded_trade_info).encrypt
    end
  end
end
