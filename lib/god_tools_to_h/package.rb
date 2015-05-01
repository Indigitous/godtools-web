module GodToolsToH
  class Package

    attr_accessor :language_code, :package_code

    def initialize(language_code, package_code)
      @language_code = language_code
      @package_code = package_code
    end

    def to_h
      translation_config = GodTools::Translations.new(language: language_code, package: package_code).config
      {}.tap do |hash|
        hash['title'] = translation_config.package_name.title
        hash.merge! GodToolsToH::PageSet.new(language_code, package_code, translation_config.page_set).to_h
      end
    end

  end
end

