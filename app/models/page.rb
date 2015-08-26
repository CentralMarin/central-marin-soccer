class Page < ActiveRecord::Base

  has_many :web_parts

  # TODO: Get created date by gathering latest date of any associated web_parts
end
