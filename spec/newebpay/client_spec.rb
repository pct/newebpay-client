RSpec.describe Newebpay do
  it "* 有版號" do
    expect(Newebpay::VERSION).not_to be nil
  end

  it "* 通過範例" do
    expect(true).to eq(true)
  end
end
