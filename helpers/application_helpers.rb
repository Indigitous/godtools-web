module ApplicationHelpers

  def booklets
    ['kgp', 'satisfied', 'fourlaws']
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

    # Handle localization
    if langs.include?(path_lang) # The path is already localized
      unlocalized_path = "/#{ path_split[2..-1].join('/') }"
    else # The path is not localized yet
      path_lang = :unspecified
      unlocalized_path = path
    end

    # Handle embedded paths
    if current_page_embedded? && !(unlocalized_path.split('/').second == 'embed')
      unlocalized_path = "/embed#{ unlocalized_path }"
    end

    desired_locale == :unspecified ? unlocalized_path : "/#{ desired_locale }#{ unlocalized_path }"
  end
  alias :l :localize_path

  def current_page_embedded?
    current_page.path.include? '/embed/'
  end

  def current_booklet
    path_params = current_page.path.split('/')
    path_params = I18n.locale == :unspecified ? path_params[1..-1] : path_params
    path_params.each do |param|
      return param if booklets.include? param
    end
    nil
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

  def booklet_nav(page)
    previous_page = page - 1
    previous_path = previous_page > 0 ? "/#{ current_booklet }/#{ previous_page }" : "/#{ current_booklet }"

    next_page = page + 1
    next_path = "/#{ current_booklet }/#{ next_page }"

    links = ''
    links += link_to(content_tag(:i, '', class: 'fa fa-arrow-left fa-lg'), l(previous_path), class: 'btn btn-default') if booklet_page_exists?(current_booklet, previous_page)
    links += link_to(content_tag(:i, '', class: 'fa fa-share-alt fa-lg'), '#', class: 'btn btn-default', data: { toggle: 'modal', target: '#share' })
    links += link_to(content_tag(:i, '', class: 'fa fa-arrow-right fa-lg'), l(next_path), class: 'btn btn-primary') if booklet_page_exists?(current_booklet, next_page)

    content_tag :nav, content_tag(:div, links, class: 'btn-group btn-group-lg btn-group-justified')
  end

  def booklet_page_exists?(booklet, page)
    I18n.exists? "#{ booklet }.page_#{ page }", 'en' # Use en locale because all of the translations exist in English.
  end

  def external_url(url)
    uri = URI(url)
    uri.scheme.blank? ? "http://#{ url }" : url
  rescue => e
    url
  end

  def embed_element_for_booklet(booklet)
    path = "/embed/#{ booklet }"
    if current_locale != :unspecified
      path = "/#{ current_locale }#{ path }"
    end
    embed_element_for_path path
  end

  def embed_element_for_path(path)
    path = path.starts_with?('/') ? path : "/#{ path }" # Make the path absolute
    content_tag :iframe, '', src: "#{ site_url }#{ path }", height: 800, width: 768, frameborder: 0, allowfullscreen: ''
  end

end
