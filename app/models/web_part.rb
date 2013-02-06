class WebPart < ActiveRecord::Base
  attr_accessible :html, :name

  translates :html, versioning: true, fallbacks_for_empty_translations: true

  validates :name, :presence => true, :uniqueness => true
  validates :html, :presence => true

  class Translation

    attr_accessible :html

    def to_s
      web_part = WebPart.find(self['web_part_id'])
      web_part.name
    end

  end

end
