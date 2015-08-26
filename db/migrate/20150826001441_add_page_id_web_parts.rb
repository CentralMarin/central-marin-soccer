class AddPageIdWebParts < ActiveRecord::Migration
  def change
		add_reference :web_parts, :page, index: true
  end
end
