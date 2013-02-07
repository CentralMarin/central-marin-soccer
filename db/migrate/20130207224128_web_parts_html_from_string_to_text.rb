class WebPartsHtmlFromStringToText < ActiveRecord::Migration
  def change
    change_table :web_parts do |t|
      t.change :html, :text
    end

    change_table :web_part_translations do |t|
      t.change :html, :text
    end
  end
end
