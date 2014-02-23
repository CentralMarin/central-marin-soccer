module TryoutRegistrationsHelper

  def parent_field_required(parent_index)
    parent_index == 1
  end

  def show_error(label, field)
    if not @tryout_registration.errors[field].empty?
      content_tag(:span, :class => 'validation-error') do
        '<br>'.html_safe + "#{label} #{@tryout_registration.errors[field].join('<br>')}"
      end
    end
  end

  def show_label(label, field, required, label_grid = 3)
    html = content_tag(:div, :class => "grid_#{label_grid}") do
      label_tag(field, "#{label} #{required ? ' *' : ''}")
    end
  end

  def show_text_field(form, label, field, required, placeholder = '', label_grid = 3, field_grid = 4)
    html = show_label(label, field, required, label_grid)

    html += content_tag(:div, :class => "grid_#{field_grid}") do
      html_content = form.text_field(field, "parsley-trigger"=>"change", required: required, placeholder: placeholder)
      html_content += show_error(label, field)
      html_content
    end

    return html
  end

  def show_checkbox(form, label, field, required, grid = 5)
    html = content_tag(:div, :class => "grid_#{grid}") do
      html_content = form.check_box(field, "parsley-trigger"=>"change", required: required)
      html_content += label_tag(field, " #{label} #{required ? ' *' : ''}")
      html_content += show_error(label, field)
    end

    return html
  end
end
