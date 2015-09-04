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

  def show_translation(locale, model, field)
    model = model.translations.find_by(locale: locale)
    if model.nil? || model.send(field).blank?
      if locale == :es
        return '<div><b>Spanish Translation Missing - Use Translate to Spanish</b></div>'.html_safe
      else
        return '<div><span class="empty">Empty</span></div>'.html_safe
      end
    end
    model.send(field).html_safe
  end
end