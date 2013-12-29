require 'spec_helper'

describe SummariesController do

  describe "GET 'byAccount'" do
    it "returns http success" do
      get 'byAccount'
      response.should be_success
    end
  end

  describe "GET 'byCategory'" do
    it "returns http success" do
      get 'byCategory'
      response.should be_success
    end
  end

end
