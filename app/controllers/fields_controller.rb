class FieldsController < InheritedResources::Base

  before_filter :set_section_name

  # GET /fields
  def index
    @fields = Field.all()
    @clubs = Field.pluck(:club).uniq
    @states = Field.states

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  protected

  def set_section_name
          @top_level_section_name = 'menu.fields'
  end
end
