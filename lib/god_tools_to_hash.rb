require 'god_tools'

class GodToolsToHash

  def initialize
    GodTools.request_authorization_key! if GodTools.authorization_key.nil?
  end

  def to_h
    {}.tap do |hash|
      languages_with_live_packages.each do |language|
        hash[language.code.downcase] = language_to_h(language)
      end
    end
  end

  private

    def all_languages
      @languages ||= GodTools::Meta.all_languages
    end

    def languages_with_live_packages
      all_languages.select do |l|
        l.packages.any? { |p| p.status == 'live' }
      end
    end

    def language_to_h(language)
      {}.tap do |hash|
        hash['language_name'] = language.name
        language.packages_by_status('live').collect(&:code).uniq.each do |package_code|
          hash[package_code] = language_package_to_h(language.code, package_code)
        end
      end
    end

    def language_package_to_h(language_code, package_code)
      translation_config = GodTools::Translations.new(language: language_code, package: package_code).config
      {}.tap do |hash|
        hash['title'] = translation_config.package_name.title
        hash.merge! page_set_to_h(language_code, package_code, translation_config.page_set)
      end
    end

    def page_set_to_h(language_code, package_code, page_set)
      {}.tap do |hash|
        page_set.each_with_index do |page, i|
          hash["page_#{ i }"] = {
            'title' => page['title'],
            'filename' => page['filename']
          }.merge page_to_h(language_code, package_code, page['filename'])
        end
      end
    end

    def page_to_h(language_code, package_code, page_filename)
      translation_page = GodTools::Translations.new(language: language_code, package: package_code).page(page_filename)
      {}.tap do |hash|
        translation_page.translated_strings.each do |string_id, string|
          hash[string_id] = string
        end
      end
    end

end
