class AmountPaidToPayments < ActiveRecord::Migration

  def change
    add_column :player_portals, :payment, :integer
  end

end
