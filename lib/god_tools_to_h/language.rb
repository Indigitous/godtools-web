module GodToolsToH
  class Language

    attr_accessor :language_meta

    def initialize(language_meta)
      @language_meta = language_meta
    end

    def to_h
      {}.tap do |hash|
        hash['language_name_in_english'] = language_meta.name
        language_meta.packages_by_status('live').collect(&:code).uniq.each do |package_code|
          hash[package_code] = GodToolsToH::Package.new(language_meta.code, package_code).to_h
        end
      end
    end

    def code
      language_meta['code']
    end

    def name
      language_meta['name']
    end

  end
end
