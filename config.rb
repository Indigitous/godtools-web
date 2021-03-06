# Add our lib folder to the load path
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'language_code'
require 'language_name_translation'

# ========================================================================
# Site settings
# ========================================================================
set :site_title,            'KnowGod.com'
set :site_description,      'KnowGod.com'
set :site_url_production,   'https://knowgod.com'
set :site_url_development,  'http://localhost:4567'
set :css_dir,               'css'
set :js_dir,                'js'
set :images_dir,            'img'
set :fonts_dir,             'fonts'
set :enable_analytics,      true


# Sitemap XML
require 'builder'
page '/sitemap.xml', layout: false

# Slim template engine
require 'slim'

# Internationalization
activate :i18n, mount_at_root: :unspecified

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

# handlebars_assets gem
require 'handlebars_assets'
ready do
  sprockets.append_path HandlebarsAssets.path
end


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

page '*/embed/*', layout: :embed

page '/404.html', directory_index: false # For Github Pages custom 404


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

# ========================================================================
# Development-specific configuration
# ========================================================================
configure :development do
  set :site_url, "#{site_url_development}"
  set :enable_analytics, false
end

# ========================================================================
# Build-specific configuration
# ========================================================================
configure :build do
  set :site_url, "#{site_url_production}"
  set :sass, line_comments: false, style: :nested

  activate :minify_css
  activate :minify_html do |html|
    html.remove_http_protocol = false  # Do not remove HTTP protocol from links.
  end
  activate :minify_javascript
  activate :gzip

  # Enable cache buster
  activate :asset_hash, :exts => ['.css', '.png', '.jpg', '.gif']

  # Ignore files/dir during build process
  ignore "environment_variables.rb"
  ignore "environment_variables.rb.sample"
  ignore "favicon_template.png"
  ignore "sitemap.yml"

  # Include .well_known directory
  config.ignored_sitemap_matchers[:source_dotfiles] = proc { |file|
    file =~ %r{/\.} && file !~ %r{/\.(well-known|htaccess|htpasswd|nojekyll)}
  }

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
