require 'god_tools'

class GodToolsLocales

  def initialize
    GodTools.request_authorization_key! if GodTools.authorization_key.nil?
    sleep 1
  end

  def meta
    @meta ||= GodTools::Meta.all
  end

  # def to_h
  #   languages_to_h
  # end

  def language_to_h(language_code)
    {
      language_code =>
        language_meta_to_h(meta.languages.detect { |l| l.code == language_code })
    }
  end

  private

    # def languages_to_h
    #   {}.tap do |hash|
    #     meta.languages.each do |language|
    #       hash[language.code.downcase] = language_to_h(language)
    #     end
    #   end
    # end

    def language_meta_to_h(language_meta)
      {}.tap do |hash|
        hash['language_name'] = language_meta.name
        language_meta.packages.each do |package|
          next unless package.status == 'live'
          hash[package.code] = language_package_to_h(language_meta.code, package.code)
        end
      end
    end

    def language_package_to_h(language_code, package_code)
      sleep 1
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
      sleep 1
      translation_page = GodTools::Translations.new(language: language_code, package: package_code).page(page_filename)
      {}.tap do |hash|
        translation_page.translated_strings.each do |string_id, string|
          hash[string_id] = string
        end
      end
    end

end
