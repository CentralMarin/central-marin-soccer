# TODO: Look into optimizing so we keep the HTML in memory and update both database and in memory versions
class WebPart < ActiveRecord::Base
  include Rails.application.routes.url_helpers # needed for _path helpers to work in models

  translates :html, fallbacks_for_empty_translations: true
  accepts_nested_attributes_for :translations, :allow_destroy => true

  belongs_to :page

  validates :name, :presence => true, :uniqueness => true
  validates :html, :presence => true

  def admin_permalink
    admin_web_part_path(self)
  end

  def self.load(names)

    return nil if names.nil?

    if (names.kind_of? String)
      names = [names]
    end

    web_parts = {}
    names.each do |name|
      web_parts[name] = WebPart.find_by(name: name)
    end

    web_parts
  end

  class Translation
    include Rails.application.routes.url_helpers # needed for _path helpers to work in models

    def admin_permalink
      admin_web_part_path(self)
    end

    def to_s
      web_part = WebPart.find(self['web_part_id'])
      web_part.name
    end

  end

end
