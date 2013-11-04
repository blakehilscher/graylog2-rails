## 0.1.1

* remove Rails.logger.info
* add configuration specs

## 0.1.0

* Refactor to prevent autoloading of graylog2-rails into middleware stack
* remove graylog2-rails/initializers.rb
* remove graylog2-rails/engine.rb
* Refactor @args.delete to use Graylog2Rails.configuration
* Refactor Graylog2Rails.configuration to cache yaml configuration