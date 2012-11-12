require 'spec_helper'

describe "Coaches" do
  describe "GET /coaches" do
    it "works! (now write some real specs)" do
      visit coaches_path

      assert current_path == coaches_path
    end
  end
end
