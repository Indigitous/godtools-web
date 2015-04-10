require_relative 'lib/god_tools_locales'

namespace :locales do
  task :update do
    print 'Fetching translated strings from the God Tools API (this can take awhile) ...'
    # locales_hash = GodToolsLocales.new.to_h
    locales_hash = GodToolsLocales.new.language_to_h('ko')
    puts ' done.'

    puts 'Writing translated strings to locale files ...'
    locales_hash.each do |locale, hash|
      print "  #{ locale }..."
      open("locales/#{ locale }.yml", 'w') do |file|
        file.write Psych.dump(locale => hash)
      end
      puts ' done.'
    end
  end
end
