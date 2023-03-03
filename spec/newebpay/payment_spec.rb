require 'securerandom'

RSpec.describe 'Newebpay::Payment 付款' do
  it "* 可發起刷卡功能，在藍新產生訂單" do
    order_prefix = "PAY"
    order_number = Newebpay.create_order_number order_prefix

    trade_info = Newebpay::Payment.new(
      order_number: order_number,
      amount: 100
    )

    res = trade_info.request!
    puts res
    #puts trade_info.required_parameters
  end
end
