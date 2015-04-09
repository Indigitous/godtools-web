# godtools-web

Web based presentation of the God Tools app.

Hosted on GitHub Pages at [https://indigitous.github.io/godtools-web](https://indigitous.github.io/godtools-web)

## Development

Setup a Ruby environment based on `.ruby-version` and `.ruby-gemset` and then run `bundle install`

Setup the environment variables:

```
cp .env.sample .env
vim .env
```

### Building

```
bundle exec middleman build
```

### Deployment

```
bundle exec middleman deploy
```

