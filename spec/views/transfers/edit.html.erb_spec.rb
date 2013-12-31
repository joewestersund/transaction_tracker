require 'spec_helper'

describe "transfers/edit" do
  before(:each) do
    @transfer = assign(:transfer, stub_model(Transfer,
      :user_id => 1,
      :from_account_id => 1,
      :to_account_id => 1,
      :amount => "9.99",
      :description => "MyText"
    ))
  end

  it "renders the edit transfer form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", transfer_path(@transfer), "post" do
      assert_select "input#transfer_user_id[name=?]", "transfer[user_id]"
      assert_select "input#transfer_from_account_id[name=?]", "transfer[from_account_id]"
      assert_select "input#transfer_to_account_id[name=?]", "transfer[to_account_id]"
      assert_select "input#transfer_amount[name=?]", "transfer[amount]"
      assert_select "textarea#transfer_description[name=?]", "transfer[description]"
    end
  end
end
