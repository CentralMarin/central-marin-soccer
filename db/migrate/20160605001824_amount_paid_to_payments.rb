class AmountPaidToPayments < ActiveRecord::Migration

  def change
    add_column :player_portals, :payment, :integer, default: 0
  end

end
