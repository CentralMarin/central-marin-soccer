require 'spec_helper'

describe "login" do
  it "should fail to login" do

    visit admin_dashboard_path

    fill_in "Email", :with => 'ryan@robinett.org'
    fill_in "Password", :with => 'password'
    click_button "Login"

    page.should have_content("Invalid email or password.")
    #save_and_open_page
  end

  it "should successfully login" do
    coach = Factory(:coach)
    adminUser = Factory(:admin_user, :roles => [Factory(:admin_role)])
    visit admin_dashboard_path

    # should get redirected to login page
    fill_in "Email", :with => adminUser.email
    fill_in "Password", :with => adminUser.password
    click_button "Login"

    assert current_path == admin_dashboard_path

    #save_and_open_page
  end
end
