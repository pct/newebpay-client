# frozen_string_literal: true

require_relative '../config'
require_relative '../errors'
require_relative '../AES/cryptographic'
require_relative '../SHA256/cryptographic'

module Newebpay
  module Period
    class AlterAmount
      attr_accessor :trade_info
      attr_reader :response

      def initialize(
        order_number: nil,
        period_no: nil,
        alter_amount: nil,
        period_type: nil,
        period_point: nil,
        period_times: nil
      )
        unless order_number && period_no
          raise Newebpay::PaymentArgumentError,
            '請確認以下參數皆有填寫:
            - order_number
            - period_no
            '
        end

        @key = Config.options[:HashKey]
        @iv = Config.options[:HashIV]

        @order_number = order_number
        @period_no = period_no
        @alter_amount = alter_amount
        @period_type = period_type
        @period_point = period_point
        @period_times = period_times

        set_trade_info
        set_post_data
      end

      def request!
        uri = URI("#{self.api_base_url}/MPG/period/AlterAmt")
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
          Version: '1.1',
          MerOrderNo: @order_number, # 商店自訂訂單編號，注意不是用 MerchantOrderNo
          PeriodNo: @period_no,
        }

        # 選填項目
        @trade_info.merge!(AlterAmt: @alter_amount) if @alter_amount
        @trade_info.merge!(PeriodType: @period_type) if @period_type
        @trade_info.merge!(PeriodPoint: @period_point) if @period_point
        @trade_info.merge!(PeriodTimes: @period_times) if @period_times
      end

      def set_post_data
        url_encoded_trade_info = URI.encode_www_form(@trade_info)
        @post_data = AES::Cryptographic.new(url_encoded_trade_info).encrypt
      end
    end
  end
end
