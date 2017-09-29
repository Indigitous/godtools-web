class LanguageNameTranslation

  SUPPLEMENTARY_TRANSLATION_DATA = {
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
    },
    'ZH_HANS' => {
      'EN' => 'Chinese, Simplified',
      'ZH_HANS' => '汉语',
      'ZH_HANT' => '汉语'
    },
    'ZH_HANT' => {
      'EN' => 'Chinese, Traditional',
      'ZH_HANS' => '漢語',
      'ZH_HANT' => '漢語'
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
      supplementary_data_translation.presence ||
        i18n_data_translation.presence ||
        supplementary_data_english_translation.presence ||
        i18n_data_english_translation.presence ||
        @language_code.code_with_country
    end

    def supplementary_data
      # These hardcoded translations are mostly here to handle the inconsistencies in the God Tools API or missing translations in I18nData
      @supplementary_data ||= SUPPLEMENTARY_TRANSLATION_DATA[@language_code.code_with_country].presence || SUPPLEMENTARY_TRANSLATION_DATA[@language_code.code]
    end

    def supplementary_data_translation
      return nil if supplementary_data.blank?
      supplementary_data[@display_in_language_code.code_with_country].presence || supplementary_data[@display_in_language_code.code]
    end

    def supplementary_data_english_translation
      return nil if supplementary_data.blank?
      supplementary_data['EN']
    end

    def i18n_data_english_translation
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
