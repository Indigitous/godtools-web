#!/bin/bash

# To automate deployment, run this script in a Heroku Scheduler (addon) like this:
# GITHUB_USERNAME=your_github_username GITHUB_PERSONAL_ACCESS_TOKEN=your_personal_access_token_created_at_github.com /app/scripts/heroku_deploy.sh

echo 'Starting Heroku deploy script ...'

# Git needs to know who we are
git config --global user.email "$GITHUB_USERNAME@users.noreply.github.com"
git config --global user.name "$GITHUB_USERNAME"

cd /tmp/

echo 'Cloning Github repo ...'
git clone "https://$GITHUB_USERNAME:$GITHUB_PERSONAL_ACCESS_TOKEN@github.com/Indigitous/godtools-web.git"

cd ./godtools-web/

echo 'Bundling ...'
# This bundle command mimicks the one that Heroku uses when it builds the app
bundle install --without development:test --path /app/vendor/bundle --binstubs /app/vendor/bundle/bin -j4 --deployment

bundle exec rake deploy

echo 'Heroku deploy script finished!'

