# Graylog2Rails

This gem provide simple wrapper for [gelf-rb gem](https://github.com/Graylog2/gelf-rb) and extending middleware
stack of rails application for exception logging to Graylog2.

## Installation

Add this line to your application's Gemfile:

    gem "graylog2-rails", "~> 0.0.1"

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install graylog2-rails

It is highly recommended to customize Graylog2Rails config

    $ rails g graylog2_rails:install

It will copy default config file into `config/graylog2_rails.conf` file.


## Usage

If you want only to catch exception and you need do nothing. To check middleware stack run `bundle exec rake middleware` and you will see something like:

```ruby
use ActionDispatch::Flash
use ActionDispatch::ParamsParser
use ActionDispatch::Head
use Graylog2Rails::Middleware <----
use Rack::ConditionalGet
use Rack::ETag
use ActionDispatch::BestStandardsSupport
use Warden::Manager
use Bullet::Rack
use Sass::Plugin::Rack
```

You also may use Graylog2Rails for logging custom messages:

```ruby
Graylog2Rails::Notifier.notify!({
  :short_message => "Your short message here",
  :full_message => "Full message"
})
```

You also may redefine default options like `facility` or pass custom filter arguments like in `gelf-rb`. For example:

```ruby
Graylog2Rails::Notifier.notify!({
  :short_message => "Your short message here",
  :full_message => "Full message",
  :_user_id => current_user.id
})
```

*You should notice that such custom options have to be started with underline*

## TODO

1. Add rspec tests
2. Cutomize message format and move it's representation to erb file

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Copyright

copyright 2012 [Artem (ignar) Melnikov](http://ignar.name)
