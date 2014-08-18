require 'rails_helper'

describe "CoachesActiveAdmins" do

  context "As an administrator" do

    before do
      login_as_admin
    end

    it "the coaches view renders with no coaches" do

      visit admin_coaches_path

      assert current_path == admin_coaches_path
    end

    it "it should create a new coach", :js => true do

      visit admin_coaches_path
      click_link "New Coach"

      coach = Coach.new(name: 'New Coach', bio: 'New bio with some <b>HTML</b>', email: 'test@test.com')
      newSpanishBio = "Esta es la bio nuevo<br/>"

      fill_in "Name", :with => coach.name
      fill_in "Email", :with => coach.email
      browser = page.driver.browser
      browser.execute_script("CKEDITOR.instances['coach_translations_attributes_0_bio'].setData('#{coach.bio}')")
      browser.execute_script("CKEDITOR.instances['coach_translations_attributes_1_bio'].setData('#{newSpanishBio}')")

      click_button "Create Coach"

      assert_path admin_coach_path(Coach.last)

      expect(page).to have_content(coach.name)
      expect(page).to have_content(html_stripped(coach.bio))
      expect(page).to have_content(html_stripped(newSpanishBio))
      expect(page).to have_content(coach.email)
    end

    context "with an existing coach" do
      before do
        @coach = FactoryGirl.create(:coach)
        visit admin_coaches_path
        assert_path admin_coaches_path
      end

      it "it should list a coach and show details" do
        expect(page).to have_content(@coach.name)
        expect(page).to have_content(html_overview(@coach.bio))
        click_link "View"
        assert_path admin_coach_path(@coach.id)
        expect(page).to have_content(@coach.name)
        expect(page).to have_content(@coach.bio)
      end

      it "he should be able to edit the coach", :js => true do
        click_link "Edit"
        assert_path edit_admin_coach_path(@coach.id)

        newName = "New Named Coach"
        newBio = "<p>This is the new bio</p>"
        newSpanishBio = "Esta es la bio nuevo<br/>"
        newEmail = "test1@test.com"
        fill_in "Name", :with => newName
        fill_in "Email", :with => newEmail
        browser = page.driver.browser
        browser.execute_script("CKEDITOR.instances['coach_translations_attributes_0_bio'].setData('#{newBio}')")
        browser.execute_script("CKEDITOR.instances['coach_translations_attributes_1_bio'].setData('#{newSpanishBio}')")
        click_button "Update Coach"

        assert_path admin_coach_path(@coach.id)
        expect(page).to have_content(newName)
        expect(page).to have_content(html_stripped(newBio))
        expect(page).to have_content(html_stripped(newSpanishBio))
        expect(page).to have_content(newEmail)
      end

      it "he should be able to delete a coach", :js => true do
        click_delete @coach
        expect(page).to have_no_content(@coach.name)
        assert_path admin_coaches_path
      end

    end
  end

end
