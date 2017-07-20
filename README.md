# godtools-web

Web based presentation of the God Tools app.

Hosted on GitHub Pages at [http://knowgod.com](http://knowgod.com)

## Development

This project is based on the [Middleman](http://middlemanapp.com/) framework.

### How to setup a development environment

1. `git clone git@github.com:Indigitous/godtools-web.git && cd godtools-web`

2. Setup a Ruby environment corresponding to the Ruby version in `.ruby-version` (this can be done with rvm, rbenv, or equivalent).

3. `bundle install`

Now you can start a local server with `bundle exec middleman server` and visit [localhost:4567](http://localhost:4567)

### Deploying Changes

At the time of writing this project is hosted on Amazon S3 using CloudFront for distrubution.

After you are happy with your changes and they are tested locally you may then commit your changes to the `master` branch.

Travis CI will pick up any commit to master, build the project and push the built version of the site to S3 if successful. Travis CI will also run a job once per day to ensure translation updates are pushed to the site even when no code changes occur.

If you want to update the locale files and deploy the Middleman app in one command then you may use the custom rake task: `bundle exec rake deploy`

### Updating the Translation Strings from the GodTools API

The translation strings originate from the GodTools API. These strings can be read from the API and then written to locale files that Middleman uses for localization ([see Middleman doc on localization](https://middlemanapp.com/advanced/localization/)). In this manner the translation strings are cached. If the translation strings need to be updated then you need to perform a manual update process.

A rake task exists to update the locale files from the API, run `bundle exec rake locales:update`

The rake task will read all of the translation strings in the API and write them to new locale files. After the task runs successfully you may commit the new locale files and run the Middleman deploy command. It would be a good idea to test the update locally before deploying.

The [godtools-gem](https://github.com/Indigitous/godtools-gem) is used to read the API.
