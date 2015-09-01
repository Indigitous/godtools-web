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

At the time of writing this project is hosted on [Github Pages](https://pages.github.com/).

After you are happy with your changes and they are tested locally you may then commit your changes to the `master` branch.

Then run `bundle exec middleman deploy` to deploy your changes to the live site.

The deploy will first run the Middleman build process, if the build is successful then it will upload the build to the `gh-pages` branch and the changes will be live. If the build process is not successful you will need to investigate and fix the build problem.

If you want to update the locale files and deploy the Middleman app in one command then you may use the custom rake task: `bundle exec rake deploy`

### Updating the Translation Strings from the GodTools API

The translation strings originate from the GodTools API. These strings can be read from the API and then written to locale files that Middleman uses for localization ([see Middleman doc on localization](https://middlemanapp.com/advanced/localization/)). In this manner the translation strings are cached. If the translation strings need to be updated then you need to perform a manual update process.

A rake task exists to update the locale files from the API, run `bundle exec rake locales:update`

The rake task will read all of the translation strings in the API and write them to new locale files. After the task runs successfully you may commit the new locale files and run the Middleman deploy command. It would be a good idea to test the update locally before deploying.

The [godtools-gem](https://github.com/Indigitous/godtools-gem) is used to read the API.

## Automating Translation Updates

Translation updates can automated using a service like Heroku. Create a new Heroku app based on this repo, then add the Heroku Scheduler addon and schedule the following script to run every day (you can disable the web server dyno, since it's not needed):

`GITHUB_USERNAME=your_github_username GITHUB_PERSONAL_ACCESS_TOKEN=your_personal_access_token_created_at_github.com /app/scripts/heroku_deploy.sh`

At the time of writing there is a Heroku app named "godtoolswebapp" already setup to automate the translation updates. Tail the Heroku logs with `heroku logs --tail --app godtoolswebapp`

Note that there is nothing too special about using Heroku here, it's just a convenient way to periodically run a rake task (you could also, for example, use a cronjob on an existing server).

