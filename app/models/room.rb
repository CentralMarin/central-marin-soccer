class Room < Location
  validates :name,  :presence => true
  validates :address, :presence => true
end