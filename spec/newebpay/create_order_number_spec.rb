RSpec.describe 'Newebpay 產生訂單編號' do
  it "* 產生訂單編號，且文字在 30 字內" do
    order_number = Newebpay.create_order_number 'PAY'
    
    puts "* 訂單編號：#{order_number}"
    puts "* 訂單編號長度：#{order_number.length}"

    expect(order_number.length).to be <= 30
  end
end
