require 'spec_helper'

describe "account_balances/show" do
  before(:each) do
    @account_balance = assign(:account_balance, stub_model(AccountBalance,
      :account_id => 1,
      :balance => "9.99"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    rendered.should match(/9.99/)
  end
end
