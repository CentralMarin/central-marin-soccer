module RegistrationsHelper
  def parent_field_required(parent_index)
    parent_index == 1
  end

  def parent_label(parent_index, label_text)
    "#{label_text} #{parent_field_required(parent_index) ? '*' : '(optional)'}"
  end

end
