require 'god_tools'

require_relative 'god_tools_to_h/language'
require_relative 'god_tools_to_h/package'
require_relative 'god_tools_to_h/page_set'
require_relative 'god_tools_to_h/page'

module GodToolsToH

  GodTools.base_uri = 'https://api.godtoolsapp.com/godtools-api/rest'
  GodTools.request_authorization_key! if GodTools.authorization_key.nil?

  def self.live_languages
    GodTools::Meta.all_languages.select do |l|
      l.packages.any? { |p| p.status == 'live' }
    end.collect do |l|
      Language.new(l)
    end
  end

  def self.language(code)
    language_meta = GodTools::Meta.all_languages.detect { |l| l.code == code }
    Language.new(language_meta)
  end

end
