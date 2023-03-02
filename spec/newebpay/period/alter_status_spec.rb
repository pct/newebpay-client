RSpec.describe 'Newebpay:Payment 付款' do
  it "* 發票 api url" do
    expect(Newebpay.api_base_url).to eq 'https://ccore.newebpay.com'
  end
end
