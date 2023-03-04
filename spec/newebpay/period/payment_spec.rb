RSpec.describe 'Newebpay::Period::Payment 定期定額付款' do
  order_prefix = "SUB"
  order_number = Newebpay.create_order_number order_prefix
  date_string = Time.now.strftime("%d")

  # 基本參數範例
  payment = Newebpay::Period::Payment.new(
    order_number: order_number,
    period_amount: 100,
    product_description: '[月] 訂閱 100 元測試',
    period_type: 'M', # 月
    period_point: date_string, # 何時刷，就下個月的當日再刷 (如果當月沒有那天，就是當月最後一天)
    period_start_type: 2, # 直接刷，不進行 10 元驗證
    period_times: 99, # 因為藍新 string(2)，所以最多 99 期
    payer_email: 'pct@4point-inc.com'
  )

  describe '* 參數除錯檢查' do
    it '* period_amount > 0' do
      expect{ Newebpay::Period::Payment.new(
        order_number: order_number,
        period_amount: 0, # 出錯點
        product_description: '[月] 訂閱 100 元測試',
        period_type: 'M',
        period_point: date_string, 
        period_start_type: 2, 
        period_times: 99, 
        payer_email: 'pct@4point-inc.com'
      ) }.to raise_error(Newebpay::PaymentArgumentError)
    end

    it '* period_type 值，只能是 D/W/M/Y' do
      expect{ Newebpay::Period::Payment.new(
        order_number: order_number,
        period_amount: 100,
        product_description: '[月] 訂閱 100 元測試',
        period_type: 'X', # 出錯點
        period_point: date_string,
        period_start_type: 2,
        period_times: 99,
        payer_email: 'pct@4point-inc.com'
      ) }.to raise_error(Newebpay::PaymentArgumentError)
    end

    it '* period_point.length <= 4 檢查' do
      expect{ Newebpay::Period::Payment.new(
        order_number: order_number,
        period_amount: 100,
        product_description: '[月] 訂閱 100 元測試',
        period_type: 'M',
        period_point: '12345', # 出錯點
        period_start_type: 2,
        period_times: 99,
        payer_email: 'pct@4point-inc.com'
      ) }.to raise_error(Newebpay::PaymentArgumentError)
    end

    it '* period_start_type 只能是 1/2/3' do
      expect{ Newebpay::Period::Payment.new(
        order_number: order_number,
        period_amount: 100,
        product_description: '[月] 訂閱 100 元測試',
        period_type: 'M',
        period_point: date_string,
        period_start_type: 4, # 出錯點 
        period_times: 99,
        payer_email: 'pct@4point-inc.com'
      ) }.to raise_error(Newebpay::PaymentArgumentError)
    end

    it '* period_times 最多 99 期 檢查，因為該欄位只能 string(2)' do
      expect{ Newebpay::Period::Payment.new(
        order_number: order_number,
        period_amount: 100,
        product_description: '[月] 訂閱 100 元測試',
        period_type: 'M',
        period_point: date_string,
        period_start_type: 2,
        period_times: 100, # 出錯點
        payer_email: 'pct@4point-inc.com'
      ) }.to raise_error(Newebpay::PaymentArgumentError)
    end
  end

  it '* 測試產生後的 params 參數' do
    params = payment.gen_period_payment_params
    expect(params[:MerchantID_]).to eq(Newebpay.options[:MerchantID])
  end

 #it "* 發起信用卡定期定額付款" do
 #  trade_info = Newebpay::Period::Payment.new(
 #    order_number: order_number,
 #    period_amount: 100,
 #    product_description: '[月] 訂閱 100 元測試',
 #    period_type: 'M', # 月
 #    period_point: date_string, # 何時刷，就下個月的當日再刷 (如果當月沒有那天，就是當月最後一天)
 #    period_start_type: 2, # 直接刷，不進行 10 元驗證
 #    period_times: 99, # 因為藍新 string(2)，所以最多 99 期
 #    payer_email: 'pct@4point-inc.com'
 #  )

 #    expect{ trade_info.test_request! }.to raise_error(JSON::ParserError)
 #end
end
