class TryoutType < ActiveRecord::Base
  active_admin_translates :header, :body

  has_many :tryouts
end
