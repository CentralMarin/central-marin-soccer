class FieldsController < InheritedResources::Base

  caches_page :index, :gzip => true

  before_filter :set_section_name

  layout 'fields'

  # GET /fields
  def index
    @fields = Field.all()
    @clubs = Field.pluck(:club).uniq
    @statuses = Field.statuses

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  protected

  def set_section_name
          @top_level_section_name = 'menu.fields'
  end
end
