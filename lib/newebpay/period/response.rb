# frozen_string_literal: true
require 'json'

require_relative '../config'
require_relative '../errors'
require_relative '../AES/cryptographic'

module Newebpay
  module Period
    class Response
      attr_reader :status, :message, :result, # 第一層資料
        :merchant_id, :order_number, :period_type, :auth_times, :date_array, :period_amount, :period_no, # Result 資料
        :auth_time, :trade_no, :card_no, :auth_code, :respond_code, :escrow_bank, :auth_bank, :payment_method, # 如果 PeriodStartType 為 1 or 2 時的額外資料
        :alter_type, :new_next_time, # AlterStatus 時的回傳值
        :alter_amount, :period_point, :new_next_amount, :period_times, :ext_day # AlterAmt 時的回傳值


      def initialize(data)
        response = JSON.parse(AES::Cryptographic.new(data['period']).decrypt)

        # 回傳參數
        @status = response['Status']
        @message = response['Message']
        @result = response['Result']

        # 從 Result 解出的參數
        @merchant_id = @result['MerchantID']
        @order_number = @result['MerchantOrderNo'] ? @result['MerchantOrderNo'] : @result['MerOrderNo'] # 因為藍新回傳 API 有不同命名 
        @period_type = @result['PeriodType']
        @auth_times = @result['AuthTimes']
        @date_array = @result['DateArray']
        @period_amount = @result['PeriodAmt']
        @period_no = @result['PeriodNo']

        # PeriodStartType 為 1 or 2 時的額外參數
        @auth_time = @result['AuthTime']
        @trade_no = @result['TradeNo']
        @card_no = @result['CardNo']
        @auth_code = @result['AuthCode']
        @respond_code = @result['RespondCode']
        @escrow_bank = @result['EscrowBank']
        @auth_bank = @result['AuthBank']
        @payment_method = @result['PaymentMethod']

        # AlterStatus 時的回傳值
        @alter_type = @result['AlterType']
        @new_next_time = @result['NewNextTime']

        # AlterAmt 時的回傳值
        @alter_amount = @result['AlterAmt'] 
        @period_point = @result['PeriodPoint'] 
        @new_next_amount = @result['NewNextAmt'] 
        @period_times = @result['PeriodTimes'] 
        @ext_day = @result['Extday']
      end

      def success?
        status == 'SUCCESS'
      end
    end
  end
end
