#!/bin/bash

# To automate deployment, run this script in a Heroku Scheduler (addon) like this:
# GITHUB_USERNAME=your_github_username GITHUB_PERSONAL_ACCESS_TOKEN=your_personal_access_token_created_at_github.com /app/scripts/heroku_deploy.sh

echo 'Starting Heroku deploy script ...'

cd /tmp/

echo 'Cloning Github repo ...'
git clone --depth 1 "https://$GITHUB_USERNAME:$GITHUB_PERSONAL_ACCESS_TOKEN@github.com/Indigitous/godtools-web.git"

cd ./godtools-web/

git config user.email "$GITHUB_USERNAME@users.noreply.github.com"
git config user.name "$GITHUB_USERNAME"

echo 'Bundling ...'
# This bundle command mimicks the one that Heroku uses when it builds the app
bundle install --without development:test --path /app/vendor/bundle --binstubs /app/vendor/bundle/bin -j4 --deployment

bundle exec rake deploy

echo 'Heroku deploy script finished!'

