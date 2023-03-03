RSpec.describe 'Newebpay::Invoice 發票' do
  it "* 發票" do
    expect(Newebpay.api_base_url).to eq 'https://ccore.newebpay.com'
  end
end
