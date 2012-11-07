class AddImageToNews < ActiveRecord::Migration
  def change
    add_column :article, :image, :string
  end
end
