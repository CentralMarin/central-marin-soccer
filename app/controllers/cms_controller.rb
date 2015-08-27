class CmsController < ApplicationController

  def init_web_parts(page_name)

    page = Page.find_by(name: page_name)

    part_name = []
    part_name = page.web_parts.map {|part| part.name } unless page.nil?
    @web_parts = WebPart.load(part_name)

    part_name = part_name[0] if part_name.length == 1
    part_name
  end

end