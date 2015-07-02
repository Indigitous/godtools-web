# Add our lib folder to the load path
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'fileutils'
require 'i18n_yaml_sorter'
require 'god_tools_to_h'

namespace :locales do

  desc 'Rewrite the locale files from the GodTools api'
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

    locales_hash['unspecified'] = locales_hash['en'] # Use english as the unspecified locale

    print 'Removing all existing yml files in locales dir ... '
    FileUtils.rm Dir.glob('locales/**/*.yml')
    puts 'done.'

    puts 'Writing translated strings to new locale files ...'
    locales_hash.each do |locale, hash|
      print "  #{ locale }.yml ... "
      open "locales/#{ locale }.yml", 'w' do |file|
        file.write Psych.dump(locale => hash)
      end
      puts 'done writing.'
    end

    puts 'Sorting the locale file contents ...'
    Rake::Task['locales:sort'].invoke

    puts 'Finished updating locale files!'
  end


  desc 'Sort all the locale yml files using gem i18n_yaml_sorter'
  task :sort do
    locale_files = Dir.glob('locales/**/*.yml')
    locale_files.each do |locale_path|
      sorted_contents = File.open(locale_path) { |f| I18nYamlSorter::Sorter.new(f).sort }
      File.open(locale_path, 'w') { |f|  f << sorted_contents}
    end
  end

end


task :deploy do
  puts 'Starting deploy task ...'

  puts 'Invoking rake task to update the locales ...'
  Rake::Task['locales:update'].invoke

  puts 'Committing the updated locale files to git ...'
  sh 'git add locales/'
  sh "git commit -m 'Update locale files - automated commit by rake deploy task'"
  sh 'git push origin master'

  puts 'Building and deploying the site with middleman ...'
  sh 'bundle exec middleman deploy'

  puts 'Deploy task finished!'
end

