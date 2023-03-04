# frozen_string_literal: true

require_relative '../config'
require_relative '../errors'
require_relative '../AES/cryptographic'
require_relative '../SHA256/cryptographic'

module Newebpay
  module Period
    class Payment
      attr_accessor :trade_info
      attr_reader :response

      def initialize(
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
        unionpay: 0, # 是否啟用銀聯卡支付方式

        # 客製回傳網址(同一個站有不同接收的 route 時使用)
        return_url: nil,
        notify_url: nil,
        back_url: nil
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

        # === 欄位檢查開始 ===
        unless period_amount > 0
          raise Newebpay::PaymentArgumentError, 'period_amount 須 > 0'
        end

        unless %w"D W M Y".include?period_type
          raise Newebpay::PaymentArgumentError, 'period_type 須為 D(日),W(週),M(月),Y(年) 四個英文字母'
        end

        unless period_point.length <= 4
          raise Newebpay::PaymentArgumentError, 'period_point 須依據文件撰寫，不能 > 4 字元'
        end

        unless %w"1 2 3".include?period_start_type.to_s
          raise Newebpay::PaymentArgumentError, 'period_start_type 只有 1(立即執行十元授權), 2(立即執行委託金額授權), 3(不檢查信用卡資訊，不授權) 三種'
        end

        unless period_times < 100
          raise Newebpay::PaymentArgumentError, 'period_times 最多就 99 期，因為藍新欄位是 string(2)'
        end
        # === 欄位檢查結束 ===

        @key = Config.options[:HashKey]
        @iv = Config.options[:HashIV]

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

        # 回傳網址
        @return_url = return_url
        @notify_url = notify_url
        @back_url = back_url

        set_trade_info
        set_post_data
      end

      def gen_period_payment_params
        {
          MerchantID_: Config.options[:MerchantID], # 商店 ID
          PostData_: @post_data
        }
      end

      # 測試用途
      def test_request!
        uri = URI("#{Config.api_base_url}/MPG/period")
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

          # 回傳網址(留意，藍新金流不同 API 命名的 BackURL 沒有統一，要特別比對)
          ReturnURL: @return_url,
          NotifyURL: @notify_url,
          BackURL: @back_url
        }
      end

      def set_post_data
        url_encoded_trade_info = URI.encode_www_form(@trade_info)
        @post_data = AES::Cryptographic.new(url_encoded_trade_info).encrypt
      end
    end
  end
end
