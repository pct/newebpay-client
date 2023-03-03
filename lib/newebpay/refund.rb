# frozen_string_literal: true

require 'net/http'
require 'json'

require_relative 'config'
require_relative 'errors'
require_relative './AES/cryptographic'
require_relative './SHA256/cryptographic'

module Newebpay
  class Refund
    attr_accessor :trade_info
    attr_reader :response

    def initialize(order_number: nil, amount: nil, cancel: false)
      unless order_number && amount
        raise Newebpay::PaymentArgumentError,
              'Please make sure that your arguments (order_number, amount) are filled in correctly'
      end

      @key = Config.options[:HashKey]
      @iv = Config.options[:HashIV]
      @order_number = order_number
      @amount = amount
      @cancel = cancel

      set_trade_info
      set_post_data
    end

    def request!
      uri = URI("#{Config.api_base_url}/API/CreditCard/Close")
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
        Version: '1.1',
        MerchantOrderNo: @order_number,
        Amt: @amount.to_i,
        TimeStamp: Time.now.to_i.to_s,
        IndexType: 1,
        CloseType: 2
      }

      return unless @cancel

      @trade_info.merge!(Cancel: 1)
    end

    def set_post_data
      url_encoded_trade_info = URI.encode_www_form(@trade_info)
      @post_data = AES::Cryptographic.new(url_encoded_trade_info).encrypt
    end
  end
end
