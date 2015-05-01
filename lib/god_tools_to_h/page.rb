module GodToolsToH
  class Page

    attr_accessor :language_code, :package_code, :filename

    def initialize(language_code, package_code, filename)
      @language_code = language_code
      @package_code = package_code
      @filename = filename
    end

    def to_h
      translation_page = GodTools::Translations.new(language: language_code, package: package_code).page(filename)
      {}.tap do |hash|
        translation_page.translated_strings.each do |string_id, string|
          hash[string_id] = string
        end
      end
    end

  end
end
