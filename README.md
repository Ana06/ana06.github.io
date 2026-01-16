# ana06.github.io

Personal website of **Ana María Martínez Gómez**: <http://anamaria.martinezgomez.name>

## Development

Built with [Jekyll](https://github.com/jekyll/jekyll) and [Bootstrap](https://github.com/twbs/bootstrap).

### Setup (Debian)
1. **Dependencies:** `sudo apt install ruby-bundler build-essential`
2. **Version Alignment:** Update `Gemfile` to match your Ruby version (`ruby -v`) and remove `Gemfile.lock`
3. **Local Environment:** `bundle config set --local path 'vendor/bundle'`
4. **Install Gems:** `bundle install`

### Run locally

Run `bundle exec jekyll serve`.
Or if you want to include future blog post (useful when working on unreleased blog post): `bundle exec jekyll serve --future`.

### License

This repository is licensed under [AGPL-3.0](AGPL-text), with the exception of the [blog posts](_posts) which are licensed under [CC BY 4.0](CC-BY-4-text), the [images](img), and where otherwise noted.

**Credits:**
* Base: [Minima Gem](https://github.com/jekyll/minima) (MIT).
* UI/Theme: [Freelancer](https://startbootstrap.com/theme/freelancer) (MIT).
* Favicon: [Favicon Generator](https://www.favicon-generator.org).
