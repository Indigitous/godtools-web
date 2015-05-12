module ApplicationHelpers

  def booklets
    ['kgp', 'satisfied', 'fourlaws']
  end

  # Gets partials from the _partials directory
  def _partial(partial_filename)
    partial "_partials/#{partial_filename}"
  end

  def current_locale
    I18n.locale
  end

  # Custom helper to output paths in a desired locale.
  # This helper method only works with absolute paths.
  def localize_path(path, desired_locale = current_locale)
    path = path.starts_with?('/') ? path : "/#{ path }" # Make the path absolute
    path_split = path.split '/'
    path_lang = path_split.second.try(:to_sym)

    # The path may or may not already have a locale specified in it
    if langs.include?(path_lang) # The path is already localized
      unlocalized_path = "/#{ path_split[2..-1].join('/') }"
    else # The path is not localized yet
      path_lang = :unspecified
      unlocalized_path = path
    end

    if desired_locale == :unspecified
       unlocalized_path
    else
      "/#{ desired_locale }#{ unlocalized_path }"
    end
  end
  alias :l :localize_path

  def current_booklet
    path_split = current_page.path.split('/')
    booklet = I18n.locale == :unspecified ? path_split.first : path_split.second
    booklets.include?(booklet) ? booklet : nil
  end

  # A hash of available locales and their booklets, this hash will be passed to the frontend js as json.
  def locale_meta
    {}.tap do |hash|
      I18n.available_locales.each do |locale|
        next unless I18n.exists? 'language_name_in_english', locale
        hash[locale] = {
          language_name_in_english: I18n.t('language_name_in_english', locale: locale),
          language_name: language_name_in_locale(locale)
        }
        hash[locale]['booklets'] = [].tap do |array|
          booklets.each { |booklet| array << booklet if I18n.exists?(booklet, locale) }
        end
      end
    end
  end

  def language_selection_s(language)
    native = language_name_in_locale(language)
    current = language_name_in_locale(language, current_locale)
    native == current || current.blank? ? native : "#{ native } (#{ current })"
  end

  def language_name_in_locale(language, locale = language)
    language_code = language.to_s[0..1].upcase
    locale_code = locale.to_s[0..1].upcase
    I18nData.languages(locale_code)[language_code] rescue I18nData.languages('EN')[language_code].presence || I18n.t('language_name_in_english', locale: language)
  end

  def booklet_nav(current_page)
    previous_page = current_page - 1
    previous_path = previous_page > 0 ? "/#{ current_booklet }/#{ previous_page }" : "/#{ current_booklet }"

    next_page = current_page + 1
    next_path = "/#{ current_booklet }/#{ next_page }"

    links = ''
    links += link_to(content_tag(:i, '', class: 'fa fa-arrow-left'), l(previous_path), class: 'btn btn-default') if booklet_page_exists?(current_booklet, previous_page)
    links += link_to(content_tag(:i, '', class: 'fa fa-arrow-right'), l(next_path), class: 'btn btn-primary') if booklet_page_exists?(current_booklet, next_page)
    content_tag :nav, content_tag(:div, links, class: 'btn-group btn-group-lg btn-group-justified')
  end

  def booklet_page_exists?(booklet, page)
    I18n.exists? "#{ booklet }.page_#{ page }", 'en' # Use en locale because all of the translations exist in English.
  end

  def external_url(url)
    uri = URI(url)
    uri.scheme.blank? ? "http://#{ url }" : url
  end

end
