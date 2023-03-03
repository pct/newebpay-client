RSpec.describe 'Newebpay::Config 設定' do
  it '* 開發/正式站 API URL' do
    if Newebpay.production_mode == 0
      # 測試站
      expect(Newebpay.api_base_url).to eq 'https://ccore.newebpay.com'
    else
      # 正式站
      expect(Newebpay.api_base_url).to eq 'https://core.newebpay.com'
    end
  end

  describe '* 產生訂單編號' do
    order_number = Newebpay.create_order_number 'PAY'

    it '* 訂單編號正確產生，且開頭有當下日期、時、分' do
      time_string = Time.now.strftime('%Y%m%d%H%M')
      puts "\t* 訂單編號：#{order_number}"
      expect(order_number.start_with?"PAY_#{time_string}").to eq(true)
    end

    it '* 訂單編號在 30 字內' do
      puts "\t* 訂單編號長度：#{order_number.length}"
      expect(order_number.length).to be <= 30
    end
  end

  it '* 取得產品付費網址(測試站)' do
    request_url = Newebpay.get_mpg_payment_url
    expect(request_url).to eq "#{Newebpay.api_base_url}/MPG/mpg_gateway"
  end

  it '* 取得定期定額刷卡網址(測試站)' do
    request_url = Newebpay.get_period_payment_url
    expect(request_url).to eq "#{Newebpay.api_base_url}/MPG/period"
  end
end
