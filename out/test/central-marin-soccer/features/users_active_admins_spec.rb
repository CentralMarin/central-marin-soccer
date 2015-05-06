require 'spec_helper'

feature "AdminUsersActiveAdmins" do

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
      click_link "New User"

      admin_user = User.new(email: 'test@test.com', password: 'password')

      fill_in "Email", :with => admin_user.email
      check :admin.to_s

      click_button "Create User"

      assert_path admin_user_path(User.last)

      page.should have_content(admin_user.email)
      page.should have_content User.show_role(:admin)
    end

    context "with an existing admin user" do
      before do
        @admin_user = User.create(email: 'test@test.com', password: 'password', roles: [:admin])
        @admin_user.save
        visit admin_users_path
        assert_path admin_users_path
      end

      it "it should list an admin user and show details" do
        page.should have_content(@admin_user.email)
        click_view(@admin_user)
        assert_path admin_user_path(@admin_user.id)
        page.should have_content(@admin_user.email)
        page.should have_content User.show_role(:admin)
      end

      it "he should be able to edit the admin user" do
        new_admin = User.new(email: 'test@test.com', password: 'password')

        click_edit(@admin_user)
        assert_path edit_admin_user_path(@admin_user.id)

        fill_in "Email", :with => new_admin.email
        uncheck :admin.to_s
        check :team_manager.to_s
        click_button "Update User"

        assert_path admin_user_path(@admin_user.id)
        page.should have_content(new_admin.email)
#        page.should have_no_content(User.show_role(:admin)) # Page has Admin all over it
        page.should have_content(User.show_role(:team_manager))
      end

      it "he should be able to delete an admin", :js => true do
        click_delete @admin_user
        page.should have_no_content(@admin_user.email)
        assert_path admin_users_path
      end

    end
  end

end
