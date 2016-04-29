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

  def show_label(form, label, field, required, label_grid = 3)
    html = content_tag(:div, :class => "grid_#{label_grid}") do
      form.label(field, "#{label} #{required ? ' *' : ''}")
    end
  end

  def show_text_field(form, label, field, required, placeholder = '', label_grid = 3, field_grid = 4)
    html = show_label(form, label, field, required, label_grid)

    html += content_tag(:div, :class => "grid_#{field_grid}") do
      html_content = form.text_field(field, required: required, placeholder: placeholder)
      html_content += show_error(label, field)
      html_content
    end

    return html
  end


  def show_telephone_field(form, label, field, required, label_grid = 3, field_grid = 4)
    html = show_label(form, label, field, required, label_grid)

    html += content_tag(:div, :class => "grid_#{field_grid}") do
      html_content = form.telephone_field(field, required: required, placeholder: '###-###-####', pattern: '^\(?([0-9]{3})\)?[-.●]?([0-9]{3})[-.●]?([0-9]{4})$')
      html_content += show_error(label, field)
      html_content
    end

    return html
  end


  def show_email_field(form, label, field, required, label_grid = 3, field_grid = 4)
    html = show_label(form, label, field, required, label_grid)

    html += content_tag(:div, :class => "grid_#{field_grid}") do
      html_content = form.text_field(field, required: required, placeholder: 'XXXX@XXXXXXX.XXX', pattern: '^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$')
      html_content += show_error(label, field)
      html_content
    end

    return html
  end

  def show_checkbox(form, label, field, required, grid = 5)
    html = content_tag(:div, :class => "grid_#{grid}") do
      html_content = form.check_box(field, required: required)
      html_content += label(field, " #{label} #{required ? ' *' : ''}")
      html_content += show_error(label, field)
    end

    return html
  end

  def show_column(heading, value, heading_grid = 3, value_grid = 4)
    html = content_tag(:div, :class => "grid_#{heading_grid}") do
      t("registration.form.#{heading}")
    end

    html += content_tag(:div, :class => "grid_#{value_grid}") do
      value
    end
  end

  def end_row()
    content_tag(:div, :class => 'clear') do
      '&nbsp;'.html_safe
    end
  end

  def show_blank_row
    html = "&nbsp;".html_safe
    html += end_row
  end

  def show_one_column(heading, value)
    html = show_column(heading, value, 3, 12)
    html += end_row
  end

  def show_two_column(heading1, value1, heading2, value2)

    html = show_column(heading1, value1)
    html += show_column(heading2, value2)
    html += end_row
  end

  def show_three_columns(heading1, value1, heading2, value2, heading3, value3)
    html = show_column(heading1, value1, 2, 3)
    html += show_column(heading2, value2, 2, 3)
    html += show_column(heading3, value3, 2, 3)
    html += end_row
  end
end