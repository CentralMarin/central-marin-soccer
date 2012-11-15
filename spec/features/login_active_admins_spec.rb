require 'spec_helper'

describe "login" do
  it "should fail to login" do

    visit admin_dashboard_path

    fill_in "Email", :with => 'ryan@robinett.org'
    fill_in "Password", :with => 'password'
    click_button "Login"

    page.should have_content("Invalid email or password.")
  end

  it "should successfully login" do
    login_as_admin
  end
end
