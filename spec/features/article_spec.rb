require 'rails_helper'

describe "Articles" do
  describe "GET /news" do
    it "works! (now write some real specs)" do
      visit articles_path
      assert current_path == articles_path
    end
  end

  #describe "Get /" do
  #  it "works! (now write some real specs)" do
  #    visit root_path
  #  end
  #end
end
