class LanguageCode

  attr_reader :code, :country_code

  def initialize(language_code_input)
    @code, @country_code = parse_language_code_input(language_code_input)
  end

  def code_with_country
    [code, country_code].select(&:present?).join('_')
  end

  private

    def parse_language_code_input(language_code_input)
      language_code_input.to_s.upcase.gsub('-', '_').split('_')
    end

end
