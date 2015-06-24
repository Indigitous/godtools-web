require 'fileutils'
require_relative 'lib/god_tools_to_h'

namespace :locales do
  task :update do
    locales_hash = {} # We'll store all the data in a hash, and then output the hash to yml files.

    puts 'Fetching translated strings from the God Tools API (this can take awhile) ...'
    GodToolsToH.live_languages.each do |language|
      print "  #{ language.name } ... "
      sleep 2 # API rate limiting.
      locales_hash[language.code] = language.to_h
      puts 'done fetching.'
    end
    raise 'Expected API to return more language!' unless locales_hash.size > 1
    locales_hash['unspecified'] = locales_hash['en']

    print 'Removing all existing yml files in locales dir ... '
    FileUtils.rm Dir.glob('locales/*.yml')
    puts 'done.'

    puts 'Writing translated strings to new locale files ...'
    locales_hash.each do |locale, hash|
      print "  #{ locale }.yml ... "
      open "locales/#{ locale }.yml", 'w' do |file|
        file.write Psych.dump(locale => hash)
      end
      puts 'done writing.'
    end

    puts 'Finished updating locale files!'
  end
end
