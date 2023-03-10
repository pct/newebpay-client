# frozen_string_literal: true

require_relative '../config'
require_relative '../errors'
require_relative '../AES/cryptographic'
require_relative '../SHA256/cryptographic'

module Newebpay
  module Period
    class AlterStatus
      attr_accessor :trade_info
      attr_reader :response

      def initialize(
        order_number: nil,
        period_no: nil,
        alter_type: nil
      )
        unless order_number && period_no && alter_type
          raise Newebpay::PaymentArgumentError,
            '請確認以下參數皆有填寫:
            - order_number
            - period_no
            - alter_type
            '
        end

        @key = Config.options[:HashKey]
        @iv = Config.options[:HashIV]

        @order_number = order_number
        @period_no = period_no
        @alter_type = alter_type

        set_trade_info
        set_post_data
      end

      def request!
        uri = URI("#{Config.api_base_url}/MPG/period/AlterStatus")
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
          MerOrderNo: @order_number, # 商店自訂訂單編號，注意不是用 MerchantOrderNo
          PeriodNo: @period_no,
          AlterType: @alter_type,
          TimeStamp: Time.now.to_i.to_s
        }
      end

      def set_post_data
        url_encoded_trade_info = URI.encode_www_form(@trade_info)
        @post_data = AES::Cryptographic.new(url_encoded_trade_info).encrypt
      end
    end
  end
end
