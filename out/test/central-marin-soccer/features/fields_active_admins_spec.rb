require 'spec_helper'

describe "FieldsActiveAdmins" do

  context "As an administrator" do

    before do
      login_as_admin
    end

    it "the fields view renders" do

      visit admin_fields_path

      assert_path admin_fields_path
    end

    it "he should create a new field" do

      visit admin_fields_path
      click_link "New Field"

      field = FactoryGirl.build(:field)
      #field = Field.new(name: 'test field', club: 'test club', rain_line: '987-123-1234', address: '335 Franklin School RoadFort Kent, ME 04743', status: 0)

      fill_in "Name", :with => field.name
      fill_in "Club", :with => field.club
      fill_in "Rain line", :with => field.rain_line
      fill_in "Address", :with => field.address
      select Field.statuses[field.status], :from => "field[status]"

      click_button "Create Field"

      assert_path admin_field_path(Field.last)

      page.should have_content(field.name)
      page.should have_content(field.club)
      page.should have_content(field.rain_line)
      page.should have_content(Field::statuses[field.status])
    end

    context "with an existing field" do
      before do
        @field = FactoryGirl.create(:field)
        visit admin_fields_path
        assert_path admin_fields_path
      end

      it "it should list a field and show details" do
        page.should have_content(@field.name)
        page.should have_content(@field.club)
        page.should have_content(@field.rain_line)
        page.should have_content(Field.statuses[@field.status])
        click_view(@field)
        assert_path admin_field_path(@field.id)
        page.should have_content(@field.name)
        page.should have_content(@field.club)
        page.should have_content(@field.rain_line)
        page.should have_content(Field.statuses[@field.status])
      end

      it "he should be able to edit the field" do
        field = FactoryGirl.build(:field)

        click_edit(@field)
        assert_path edit_admin_field_path(@field.id)

        fill_in "Name", :with => field.name
        fill_in "Club", :with => field.club
        fill_in "Rain line", :with => field.rain_line
        fill_in "Address", :with => field.address
        select Field.statuses[field.status], :from => "field[status]"
        click_button "Update Field"

        assert_path admin_field_path(@field.id)

        page.should have_content(field.name)
        page.should have_no_content(@field.name)
        page.should have_content(field.club)
        page.should have_content(field.rain_line)
        page.should have_content(Field.statuses[field.status])
      end

      it "he should be able to delete a field", :js => true do
        click_delete @field
        page.should have_no_content(@field.name)
        assert_path admin_fields_path
      end

    end
  end

end
