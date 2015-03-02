class TryoutType < ActiveRecord::Base
  active_admin_translates :header, :body

  has_many :tryouts

  validates :header, :presence => true

  def to_s
    name
  end

end
