module ActiveAdmin::ViewHelpers

  def html_overview(html)
    truncate(strip_tags(html), :length => 400, :omission => ' ...', :separator => ' ')
  end

  def html_stripped(html)
    strip_tags(html)
  end

  def show_translated_model_field(model, field)
    # If English is empty, no reason to show suggestion about Spanish
    english, result = show_translated_model_field_for_locale(:en, model.translations.where(locale: :en).first, field)
    if result
      spanish, result = show_translated_model_field_for_locale(:es, model.translations.where(locale: :es).first, field)
      english = english + spanish
    end

    english
  end

  protected

  def show_translated_model_field_for_locale(locale, model, field)
      if (model.nil? || model.send(field).blank?)
        if locale == :es
          return '<div><b>Spanish Translation Missing - considering using google translate to get the point across</b></div>'.html_safe, true
        else
          return '<div><span class="empty">Empty</span></div>'.html_safe, false
        end
      else
        return model.send(field).html_safe, true
      end
  end
end