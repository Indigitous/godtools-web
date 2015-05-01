module GodToolsToH
  class PageSet

    attr_accessor :language_code, :package_code

    def initialize(language_code, package_code, page_set_config = nil)
      @language_code = language_code
      @package_code = package_code
      @page_set_config = page_set_config
    end

    def to_h
      {}.tap do |hash|
        page_set_config.each_with_index do |page, i|
          hash["page_#{ i }"] = {
            'title' => page['title'],
            'filename' => page['filename']
          }.merge GodToolsToH::Page.new(language_code, package_code, page['filename']).to_h
        end
      end
    end

    private

      def page_set_config
        @page_set_config ||= GodTools::Translations.new(language: language_code, package: package_code).config.page_set
      end

  end
end
