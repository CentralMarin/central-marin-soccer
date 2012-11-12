require 'spec_helper'

describe "News" do
  describe "GET /news" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get articles_index_path
      response.status.should be(200)
    end
  end

  describe "Get /" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get root_path
      response.status.should be(200)
    end
  end
end
