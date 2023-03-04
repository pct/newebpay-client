RSpec.describe 'Newebpay::Payment 付款' do
  describe '* 檢查付款表單裡面的值' do
    order_prefix = "PAY"
    order_number = Newebpay.create_order_number order_prefix

    trade_info = Newebpay::Payment.new(
      order_number: order_number,
      amount: 100
    )

    params = trade_info.gen_mpg_payment_params

    puts Newebpay.get_mpg_payment_url
    puts params

    it '* 測試商店 ID 有正確代入' do
      expect(params[:MerchantID]).to eq Newebpay.options[:MerchantID]
    end

    it '* 測試版本要為 2.0' do
      expect(params[:Version]).to eq '2.0' #一定要是 2.0，否則就是這個 gem 要跟著升級改寫
    end
  end

  ### 測試發起藍新訂單「頁面」，尚未能 post
  #it "* 可發起刷卡功能，在藍新產生訂單" do
  #  order_prefix = "PAY"
  #  order_number = Newebpay.create_order_number order_prefix

  #  trade_info = Newebpay::Payment.new(
  #    order_number: order_number,
  #    amount: 100
  #  )

  #  res = trade_info.request!
  #  puts res
  #end
end
