# frozen_string_literal: true

require_relative 'config'
require_relative 'errors'
require_relative './AES/cryptographic'
require_relative './SHA256/cryptographic'

module Newebpay
  class QueryTradeInfo
    attr_accessor :trade_info
    attr_reader :response

    def initialize(
      order_number: nil,
      amount: nil,
      gateway: nil
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
      @gateway = gateway

      set_trade_info
      set_check_value
    end

    def request!
      uri = URI("#{self.api_base_url}/API/QueryTradeInfo")

      res = Net::HTTP.post_form(uri,
        MerchantID: Config.options[:MerchantID], # 若要用複合式商店代號(MS5 開頭)，則[Gateway]參數為必填
        Version: '1.3',
        RespondType: 'JSON',
        CheckValue: @check_value,
        TimeStamp: Time.now.to_i.to_s,
        MerchantOrderNo: @order_number,
        Amt: @amount.to_i,
        Gateway: @gateway #若為複合式商店(MS5 開頭) ，此欄位為必填
      )

      @response = JSON.parse(res.body)
    end

    def success?
      return if @response.nil?

      @response['Status'] == 'SUCCESS'
    end

    private

    def set_trade_info
      # 變數順序不能變，要作為 check_value：IV 在前、資料中間，Key 最後 (與 payment 需要的 check 寫法要 AES 再 SHA256 不同)
      @trade_info = {
        IV: Config.options[HashIV],
        Amt: @amount.to_i,
        MerchantID: Config.options[:MerchantID],
        MerchantOrderNo: @order_number,
        Key: Config.options[HashKey]
      }
    end

    def set_check_value
      url_encoded_trade_info = URI.encode_www_form(@trade_info)
      @check_value = Digest::SHA256.hexdigest(url_encoded_trade_info).upcase
    end
  end
end
