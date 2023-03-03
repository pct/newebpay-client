# frozen_string_literal: true

require 'net/http'
require 'json'

require_relative 'config'
require_relative 'errors'
require_relative './AES/cryptographic'
require_relative './SHA256/cryptographic'

module Newebpay
  class Payment
    attr_accessor :trade_info
    attr_reader :response

    def initialize(
      # 必填參數
      order_number: nil,
      amount: nil,

      # 參數
      product_description: '產品說明',
      email: '',
      order_comment: '',

      # 客製回傳網址(同一個站有不同接收的 route 時使用)
      return_url: nil,
      notify_url: nil,
      back_url: nil
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
      @order_comment = order_comment
      @amount = amount
      @email = email
      @product_description = product_description

      # 回傳網址
      @return_url = return_url
      @notify_url = notify_url
      @back_url = back_url

      set_trade_info

      @aes_trade_info = AES::Cryptographic.new(url_encoded_trade_info).encrypt
      @sha256_trade_info = SHA256::Cryptographic.new(@aes_trade_info).encrypt
    end

    def gen_mpg_payment_params
      {
        MerchantID: Config.options[:MerchantID], # 商店 ID
        TradeInfo: @aes_trade_info, # AES 加密過的 trade info
        TradeSha: @sha256_trade_info, # sha256 加密過的 trade info
        Version: '2.0' # 藍新金流版本號
      }
    end

    # 測試有無藍新參數錯誤用
    #def test_request!
    #  uri = URI("#{Config.api_base_url}/MPG/mpg_gateway")
    #  res = Net::HTTP.post_form(uri,
    #    MerchantID: Config.options[:MerchantID],
    #    TradeInfo: @aes_trade_info,
    #    TradeSha: @sha256_trade_info,
    #    Version: '2.0'
    #  )
    #  @response = JSON.parse(res.body)
    #end

    #def success?
    #  return if @response.nil?
    #  @response['Status'] == 'SUCCESS'
    #end

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
        Email: @email, # 用戶的 Email
        Version: '2.0', # 寫死 Version 2.0
        RespondType: 'JSON',

        # 回傳網址
        ReturnURL: @return_url,
        NotifyURL: @notify_url,
        ClientBackURL: @back_url,
      }

      @trade_info.merge!(individual_trade_info)
    end
  end
end
