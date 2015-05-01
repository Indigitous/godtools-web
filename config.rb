require 'dotenv'
Dotenv.load

# ========================================================================
# Site settings
# ========================================================================
set :site_title,            "God Tools Web"
set :site_description,      "God Tools Web"
set :site_url_production,   ENV['SITE_URL_PRODUCTION']
set :site_url_development,  ENV['SITE_URL_DEVELOPMENT']
set :css_dir,               'css'
set :js_dir,                'js'
set :images_dir,            'img'
set :fonts_dir,             'fonts'

# Sitemap URLs (use trailing slashes)
set :url_sample,            "/sample/"
# Place additional URLs here...

# Sitemap XML
require "builder"
page "/sitemap.xml", :layout => false

# Slim template engine
require "slim"

# Internationalization
activate :i18n, mount_at_root: :unspecified

# Use relative URLs
activate :relative_assets

# Pretty URLs
activate :directory_indexes

# Autoprefixer
activate :autoprefixer do |config|
  config.browsers = ['last 2 versions', 'Explorer >= 9']
  config.cascade  = false
  config.inline   = false
end

# Sprocket support for Bower
sprockets.append_path File.join root, 'bower_components'

# Bh - Bootstrap helpers
activate :bh

# Reload the browser automatically whenever files change
activate :livereload

# ========================================================================
# Page options, layouts, aliases and proxies
# ========================================================================

# Per-page layout changes:
#
# With no layout
# page "/path/to/file.html", :layout => false
#
# With alternative layout
# page "/path/to/file.html", :layout => :otherlayout
#
# A path which all have the same layout
# with_layout :admin do
#   page "/admin/*"
# end

# Proxy pages (http://middlemanapp.com/basics/dynamic-pages/)
# proxy "/this-page-has-no-template.html", "/template-file.html",
# :locals => {:which_fake_page => "Rendering a fake page with a local
# variable" }


# ========================================================================
# Helpers
# ========================================================================

# Automatic image dimensions on image_tag helper
# activate :automatic_image_sizes

# Methods defined in the helpers block are available in templates
# helpers do
#   def some_helper
#     "Helping"
#   end
# end

helpers do

  def booklets
    ['kgp', 'satisfied', 'fourlaws']
  end

  # Gets partials from the _partials directory
  def _partial(partial_filename)
    partial "_partials/#{partial_filename}"
  end

  def current_locale
    I18n.locale
  end

  def locale?
    current_locale != I18n.default_locale
  end

  # Custom helper to output paths in a desired locale.
  # This helper method only works with absolute paths.
  def localize_path(path, desired_locale = current_locale)
    path = path.starts_with?('/') ? path : "/#{ path }" # Make the path absolute
    path_split = path.split '/'
    path_lang = path_split.second.try(:to_sym)

    # The path may or may not already have a locale specified in it
    if langs.include?(path_lang) # The path is already localized
      unlocalized_path = "/#{ path_split[2..-1].join('/') }"
    else # The path is not localized yet
      path_lang = :unspecified
      unlocalized_path = path
    end

    if desired_locale == :unspecified
       unlocalized_path
    else
      "/#{ desired_locale }#{ unlocalized_path }"
    end
  end
  alias :l :localize_path

  def current_booklet
    path_split = current_page.path.split('/')
    booklet = I18n.locale == :unspecified ? path_split.first : path_split.second
    booklets.include?(booklet) ? booklet : nil
  end

  # A hash of available locales and their booklets, this hash will be passed to the frontend js as json.
  def locale_meta
    {}.tap do |hash|
      I18n.available_locales.each do |locale|
        next unless I18n.exists? 'language_name_in_english', locale
        hash[locale] = {
          language_name_in_english: I18n.t('language_name_in_english', locale: locale),
          language_name: language_name_in_locale(locale)
        }
        hash[locale]['booklets'] = [].tap do |array|
          booklets.each { |booklet| array << booklet if I18n.exists?(booklet, locale) }
        end
      end
    end
  end

  def language_selection_s(language)
    native = language_name_in_locale(language)
    current = language_name_in_locale(language, current_locale)
    native == current || current.blank? ? native : "#{ native } (#{ current })"
  end

  def language_name_in_locale(language, locale = language)
    language_code = language.to_s[0..1].upcase
    locale_code = locale.to_s[0..1].upcase
    I18nData.languages(locale_code)[language_code] rescue I18nData.languages('EN')[language_code].presence || I18n.t('language_name_in_english', locale: language)
  end

end


# ========================================================================
# Development-specific configuration
# ========================================================================
configure :development do
  set :site_url, "#{site_url_development}"
end

# ========================================================================
# Build-specific configuration
# ========================================================================
configure :build do
  set :site_url, "#{site_url_production}"
  set :sass, line_comments: false, style: :nested

  activate :minify_css
  activate :minify_html
  activate :minify_javascript
  activate :gzip

  # Enable cache buster
  activate :asset_hash, :exts => ['.css', '.png', '.jpg', '.gif']

  # Ignore files/dir during build process
  ignore "environment_variables.rb"
  ignore "environment_variables.rb.sample"
  ignore "favicon_template.png"
  ignore "sitemap.yml"
  ignore "imageoptim.manifest.yml"

  # Compress and optimise images during build
  # Documentation: https://github.com/plasticine/middleman-imageoptim
  activate :imageoptim do |options|
    # Image extensions to attempt to compress
    options.image_extensions = %w(.png .jpg .gif .svg)
    # Cause image_optim to be in shouty-mode
    options.verbose = false
  end

  # Create favicon and device-specific icons
  # Edit favicon_template.png for custom icon
  activate :favicon_maker, :icons => {
    "favicon_template.png" => [
      { icon: "apple-touch-icon-152x152-precomposed.png" },
      { icon: "apple-touch-icon-144x144-precomposed.png" },
      { icon: "apple-touch-icon-120x120-precomposed.png" },
      { icon: "apple-touch-icon-114x114-precomposed.png" },
      { icon: "apple-touch-icon-76x76-precomposed.png" },
      { icon: "apple-touch-icon-72x72-precomposed.png" },
      { icon: "apple-touch-icon-60x60-precomposed.png" },
      { icon: "apple-touch-icon-57x57-precomposed.png" },
      { icon: "apple-touch-icon-precomposed.png", size: "57x57" },
      { icon: "apple-touch-icon.png", size: "57x57" },
      { icon: "favicon-196x196.png" },
      { icon: "favicon-160x160.png" },
      { icon: "favicon-96x96.png" },
      { icon: "favicon-32x32.png" },
      { icon: "favicon-16x16.png" },
      { icon: "favicon.png", size: "16x16" },
      { icon: "favicon.ico", size: "64x64,32x32,24x24,16x16" },
      { icon: "mstile-144x144", format: "png" },
    ]
  }
end

# ========================================================================
# Deployment-specific configuration
# ========================================================================
# Middleman-deploy can deploy a site via rsync, ftp, sftp, or git.
# Documentation: https://github.com/karlfreeman/middleman-deploy
# ========================================================================
activate :deploy do |deploy|
  deploy.method = :git
  deploy.build_before = true
  # Optional Settings
  # deploy.remote   = 'custom-remote' # remote name or git url, default: origin
  # deploy.branch   = 'custom-branch' # default: gh-pages
  # deploy.strategy = :submodule      # commit strategy: can be :force_push or :submodule, default: :force_push
  # deploy.commit_message = 'custom-message'      # commit message (can be empty), default: Automated commit at `timestamp` by middleman-deploy `version`
end
