module ActiveAdminMacros

  def login_as_admin
    adminUser = FactoryGirl.create(:user, :admin_user)
    visit new_user_session_path

    # should get redirected to login page
    fill_in "Email", :with => adminUser.email
    fill_in "Password", :with => adminUser.password
    click_button "Login"
  end

  def assert_path expected_path
    assert current_path == expected_path, "Current path #{current_path} != expected path #{expected_path}"
  end

  def click_view object
    find_row(object).find_link('View').click
  end

  def click_edit object
    find_row(object).find_link('Edit').click
  end

  def click_delete object
    page.evaluate_script('window.confirm= function() { return true; }')
    find_row(object).find_link('Delete').click
  end

  protected

  def find_row object
    find_by_id("#{object.class.to_s.tableize.singularize}_#{object.id}")
  end
end