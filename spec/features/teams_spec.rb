require 'spec_helper'

describe "Teams" do
  describe "GET /teams" do
    it "works! (now write some real specs)" do
      visit teams_path
      assert current_path == teams_path
    end
  end
end
