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
        # 必填客製網址(同一個站有不同接收的 route 時使用)
        return_url: nil,
        notify_url: nil,
        back_url: nil,

        # 必填參數
        order_number: nil,
        product_description: '產品說明',
        period_amount: nil,
        period_type: nil,
        period_point: nil,
        period_start_type: nil,
        period_times: nil,
        payer_email: nil,

        # 選填
        period_firstdate: nil, # 指定首期授權日期，此日期當天會執行第1次授權，隔日為授權週期起算日。
        period_memo: '委託扣款備註說明',
        email_modify: 1, # 於付款頁面，付款人電子信箱欄位是否開放讓付款人修改
        payment_info: 'Y', # 付款人填寫此委託時，是否需顯示付款人資訊填寫欄位
        order_info: 'N', # 付款人填寫此委託時，是否需顯示收件人資訊填寫欄位 (預設為 Y 要寫，但通常商城不用寫)
        unionpay: 1 # 是否啟用銀聯卡支付方式
      )
        unless return_url && notify_url && back_url && order_number && period_amount && period_type && period_point && period_start_type && period_times && payer_email
          raise Newebpay::PaymentArgumentError,
            '請確認以下參數皆有填寫:
            - return_url
            - notify_url
            - back_url

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

        @return_url = return_url
        @notify_url = notify_url
        @back_url = back_url

        @order_number = order_number
        @product_description = product_description
        @period_amount = period_amount
        @period_type = period_type
        @period_point = period_point
        @period_start_type = period_start_type
        @period_times = period_times
        @payer_email = payer_email

        @period_firstdate = period_firstdate
        @period_memo = period_memo
        @email_modify = email_modify
        @payment_info = payment_info
        @order_info =  order_info
        @unionpay = unionpay

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
          # 網址
          ReturnURL: @return_url,
          NotifyURL: @notify_url,
          BackURL: @back_url,

          # 必填參數
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
          PayerEmail: @payer_email,

          # 選填
          PeriodFirstdate: @period_firstdate,
          PeriodMemo: @period_memo,
          EmailModify: @email_modify, # 付款人電子信箱欄位是否開放讓付款人修改
          PaymentInfo: @payment_info, # 付款人填寫此委託時，是否需顯示付款人資訊填寫欄位
          OrderInfo: @order_info, # 付款人填寫此委託時，是否需顯示收件人資訊填寫欄位 (預設為 Y, 但考量一般網路購物不大需要，所以寫 N)
          UNIONPAY: @unionpay, # 是否啟用銀聯卡支付方式
        }
      end

      def set_post_data
        url_encoded_trade_info = URI.encode_www_form(@trade_info)
        @post_data = AES::Cryptographic.new(url_encoded_trade_info).encrypt
      end
    end
  end
end
