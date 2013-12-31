require 'spec_helper'

describe "transfers/show" do
  before(:each) do
    @transfer = assign(:transfer, stub_model(Transfer,
      :user_id => 1,
      :from_account_id => 2,
      :to_account_id => 3,
      :amount => "9.99",
      :description => "MyText"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    rendered.should match(/2/)
    rendered.should match(/3/)
    rendered.should match(/9.99/)
    rendered.should match(/MyText/)
  end
end
