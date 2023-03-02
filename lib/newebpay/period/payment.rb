# frozen_string_literal: true

require_relative 'config'
require_relative 'errors'
require_relative './AES/cryptographic'
require_relative './SHA256/cryptographic'

module Newebpay
  module Period
    class Payment
      attr_accessor :trade_info
      attr_reader :response

      def initialize(
        order_number: nil,
        product_description: '產品說明',
        period_amount: nil,
        period_type: nil,
        period_point: nil,
        period_start_type: nil,
        period_times: nil,
        payer_email: nil
      )
        unless order_number && period_amount && period_type && period_point && period_start_type && period_times && payer_email
          raise Newebpay::PaymentArgumentError,
            '請確認以下參數皆有填寫:
            - order_number
            - product_description
            - period_amount
            - period_type
            - period_point
            - period_start_type
            - period_times
            - payer_email
            '
        end

        @key = Config.options[:HashKey]
        @iv = Config.options[:HashIV]

        @order_number =  order_number
        @product_description = product_description
        @period_amount = period_amount
        @period_type = period_type
        @period_point = period_point
        @period_start_type = period_start_type
        @period_times = period_times
        @payer_email = payer_email

        set_trade_info
        set_post_data
      end

      def request!
        uri = URI("#{self.api_base_url}/MPG/period")
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
          TimeStamp: Time.now.to_i.to_s,
          Version: '1.5',
          MerOrderNo: @order_number, # 商店自訂訂單編號，注意不是用 MerchantOrderNo
          ProdDesc: @product_description,
          PeriodAmt: @period_amount.to_i,
          PeriodType: @period_type,
          PeriodPoint: @period_point,
          PeriodStartType: @period_start_type,
          PeriodTimes: @period_times,
          PayerEmail: @payer_email
        }
      end

      def set_post_data
        url_encoded_trade_info = URI.encode_www_form(@trade_info)
        @post_data = AES::Cryptographic.new(url_encoded_trade_info).encrypt
      end
    end
  end
end
