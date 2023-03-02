RSpec.describe 'Newebpay.Config 設定' do
  it "* 開發/正式站 API URL" do
    if Newebpay.production_mode == 0
      # 測試站
      expect(Newebpay.api_base_url).to eq 'https://ccore.newebpay.com'
    else
      # 正式站
      expect(Newebpay.api_base_url).to eq 'https://core.newebpay.com'
    end
  end
end
