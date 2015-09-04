module ActiveAdmin::ViewHelpers

  def html_overview(html)
    truncate(strip_tags(html), :length => 400, :omission => ' ...', :separator => ' ')
  end

  def html_stripped(html)
    strip_tags(html)
  end

  def show_tanslated(context, model, field)
    english_model = translation_model(:en, model)
    spanish_model = translation_model(:es, model)

    has_english = translation?(english_model, field)
    has_spanish = translation?(spanish_model, field)

    english_translation = translation(english_model, field)
    spanish_translation = translation(spanish_model, field)

    empty = '<div><span class="empty">Empty</span></div>'.html_safe

    context.instance_exec do
      columns do
        column do
          has_english ? english_translation : empty
        end
        column do
          if has_spanish
            spanish_translation
          else
            has_english ? '<div><b>Spanish Translation Missing - Use Translate to Spanish button</b></div>'.html_safe : empty
          end
        end
      end
    end
  end

  protected

  def translation_model(locale, model)
    model.translations.find_by(locale: locale)
  end

  def translation(translation_model, field)
    translation_model.send(field).html_safe if translation?(translation_model, field)
  end

  def translation?(translation_model, field)
    !(translation_model.nil? || translation_model.send(field).blank?)
  end
end