require 'rails_helper'

describe "login" do
  it "should fail to login" do

    visit admin_dashboard_path

    fill_in "Email", :with => Faker::Internet.email
    fill_in "Password", :with => Faker::Internet.password
    click_button "Login"

    expect(page).to have_text("Invalid email or password.")
  end

  it "should successfully login" do
    login_as_admin
  end
end
