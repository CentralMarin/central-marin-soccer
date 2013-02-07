# TODO: Look into optimizing so we keep the HTML in memory and update both database and in memory versions
class WebPart < ActiveRecord::Base
  include Rails.application.routes.url_helpers # needed for _path helpers to work in models

  attr_accessible :html, :name

  translates :html, versioning: true, fallbacks_for_empty_translations: true

  validates :name, :presence => true, :uniqueness => true
  validates :html, :presence => true

  def admin_permalink
    admin_web_part_path(self)
  end

  def self.load(names)

    if (names.kind_of? String)
      names = [names]
    end

    web_parts = {}
    names.each do |name|
      web_parts[name] = WebPart.find_by_name(name)
    end

    web_parts
  end

  class Translation
    include Rails.application.routes.url_helpers # needed for _path helpers to work in models

    attr_accessible :html

    def admin_permalink
      admin_web_part_path(self)
    end

    def to_s
      web_part = WebPart.find(self['web_part_id'])
      web_part.name
    end

  end

end