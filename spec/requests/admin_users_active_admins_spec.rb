require 'spec_helper'

describe "AdminUsersActiveAdmins" do

  context "As an administrator" do

    before do
      login_as_admin
    end

    it "the admin users view renders" do

      visit admin_users_path

      assert current_path == admin_users_path
    end

    it "he should create a new admin user" do

      visit admin_users_path
      click_link "New Admin User"

      admin_user = User.new(email: 'test@test.com', password: 'password')
      role = 'admin'

      fill_in "Email", :with => admin_user.email
      fill_in "Password", :with => admin_user.password
      check(role)

      click_button "Create Admin user"

      assert_path admin_user_path(User.last)

      page.should have_content(admin_user.email)
      page.should have_content(role)
    end

    context "with an existing admin user" do
      before do
        @admin_role = Role.first
        @admin_user = User.create(email: 'test@test.com', password: 'password')
        @admin_user.roles = [@admin_role]
        @admin_user.save
        visit admin_users_path
        assert_path admin_users_path
      end

      it "it should list an admin user and show details" do
        page.should have_content(@admin_user.email)
        click_view(@admin_user)
        assert_path admin_admin_user_path(@admin_user.id)
        page.should have_content(@admin_user.email)
        page.should have_content(@admin_role.name)
      end

      it "he should be able to edit the admin user" do
        new_admin = User.new(email: 'test@test.com', password: 'password')
        new_role = Factory(:manager_role)

        click_edit(@admin_user)
        assert_path edit_admin_user_path(@admin_user.id)

        fill_in "Email", :with => new_admin.email
        fill_in "Password", :with => new_admin.password
        uncheck @admin_role.name
        check new_role.name
        click_button "Update Admin user"

        assert_path admin_user_path(@admin_user.id)
        page.should have_content(new_admin.email)
        page.should have_no_content(@admin_role.name)
        page.should have_content(new_role.name)
      end

      it "he should be able to delete a admin", :js => true do
        click_delete @admin_user
        page.should have_no_content(@admin_user.email)
        assert_path admin_users_path
      end

    end
  end

end
