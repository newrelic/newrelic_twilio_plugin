# New Relic Twilio

This tool provides the New Relic Twilio metric collection agent.

## Dependencies
- A single machine
- Ruby (>= 1.8.7)
- Rubygems (>= 1.3.7)
- Bundler `gem install bundler`

## Install
1. Download the latest tagged version from `https://github.com/newrelic-platform/newrelic_twilio_plugin/tags`
2. Extract to the location you want to run the extention from
3. Rename `config/template_newrelic_plugin.yml` to `config/newrelic_plugin.yml`
4. Edit `config/newrelic_plugin.yml` and replace "YOUR_LICENSE_KEY_HERE" with your New Relic license key
5. Run `bundle install`
6. Run `bundle exec ./bin/newrelic_twilio`

## Todo
- Change the overall call & sms count metric names, to re-enable stacked charts using a wildcard
