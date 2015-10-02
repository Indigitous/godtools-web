class LanguageNameTranslation

  SUPPLEMENTARY_TRANSLATIONS = {
    'TGL' => {
      'EN' => 'Tagalog',
      'TGL' => 'Wikang Tagalog'
    },
    'TL' => {
      'EN' => 'Tagalog',
      'TL' => 'Wikang Tagalog'
    },
    'NSO' => {
      'EN' => 'Northern Sotho'
    },
    'BO' => {
      'EN' => 'Tibetan',
      'BO' => 'བོད་ཡིག'
    },
    'SQ' => {
      'EN' => 'Albanian',
      'SQ' => 'Shqip'
    },
    'HY' => {
      'EN' => 'Armenian',
      'HY' => 'Հայերեն'
    },
    'SN' => {
      'EN' => 'Shona',
      'SN' => 'chiShona'
    },
    'SW' => {
      'EN' => 'Swahili',
      'SW' => 'Kiswahili'
    },
    'SI' => {
      'EN' => 'Sinhala, Sinhalese',
      'SI' => 'සිංහල'
    }
  }

  def initialize(language:, display_in_language: language)
    @language_code = LanguageCode.new(language)
    @display_in_language_code = LanguageCode.new(display_in_language).presence || @language_code
  end

  def name
    @name ||= translate_name
  end

  private

    def translate_name
      i18n_data_translation.presence ||
        supplementary_translation.presence ||
        english_translation.presence ||
        @language_code.code_with_country
    end

    def supplementary_translation
      # These hardcoded translations are mostly here to handle the inconsistencies in the God Tools API or missing translations in I18nData
      translations = SUPPLEMENTARY_TRANSLATIONS[@language_code.code_with_country].presence || SUPPLEMENTARY_TRANSLATIONS[@language_code.code]
      return nil if translations.blank?
      translations[@display_in_language_code.code_with_country].presence || translations[@display_in_language_code.code].presence || translations['EN']
    end

    def english_translation
      i18n_data_translation(display_in_language_code: LanguageCode.new('EN')).presence ||
        I18n.t('language_name_in_english', locale: @language_code.code_with_country).presence ||
        I18n.t('language_name_in_english', locale: @language_code.code)
    end

    # Try to get the translation from the I18nData library
    def i18n_data_translation(language_code: @language_code, display_in_language_code: @display_in_language_code)
      display_in_language_code_string = display_in_language_code.code_with_country # First try translating with the country code
      begin
        languages = I18nData.languages(display_in_language_code_string)
        languages[language_code.code_with_country].presence || languages[language_code.code]
      rescue I18nData::NoTranslationAvailable
        if display_in_language_code_string != display_in_language_code.code # If we couldn't translate using the country code then retry without the country
          display_in_language_code_string = display_in_language_code.code
          retry
        end
        nil
      end
    end

end
