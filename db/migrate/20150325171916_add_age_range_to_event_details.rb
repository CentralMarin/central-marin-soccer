class AddAgeRangeToEventDetails < ActiveRecord::Migration
  def change
    add_column :event_details, :boys_age_range, :string
    add_column :event_details, :girls_age_range, :string
  end
end
