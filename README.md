# ApiTaster [![Build Status](https://secure.travis-ci.org/fredwu/api_taster.png?branch=master)](http://travis-ci.org/fredwu/api_taster) [![Dependency Status](https://gemnasium.com/fredwu/api_taster.png)](https://gemnasium.com/fredwu/api_taster)

A quick and easy way to visually test out your Rails application's API.

![](http://i.imgur.com/8Dnto.png)

## Why?

There are already many awesome API clients (such as [Postman](https://chrome.google.com/webstore/detail/fdmmgilgnpjigdojojpjoooidkmcomcm)), so why reinvent the wheel?

API Taster compared to alternatives, have the following advantages:

- API endpoints are automatically generated from your Rails routes definition
- Defining post params is as easy as defining routes
- Post params can be shared with your test factories

## Usage

Add API Taster in your gemfile:

```ruby
gem 'api_taster', :group => :development
```
Mount API Taster, this will allow you to visit API Taster from within your app. For example:

```ruby
Rails.application.routes.draw do
  mount ApiTaster::Engine => "/api_taster" if Rails.env.development?
end
```

Add API Taster into the autoload paths in `development.rb`:

```ruby
config.autoload_paths += %W(
  #{ApiTaster::Engine.root}
)
```

In `routes.rb`, define parameters for each API endpoint after the normal routes definition block. For example:

```ruby
if Rails.env.development?
  ApiTaster.routes do
    get '/users'

    post '/users', {
      :user => {
        :name => 'Fred'
      }
    }

    get '/users/:id', {
      :id => 1
    }

    put '/users/:id', {
      :id => 1, :user => {
        :name => 'Awesome'
      }
    }

    delete '/users/:id', {
      :id => 1
    }
  end
end
```

### Share Params with Test Factories

If you use a test factory such as [FactoryGirl](https://github.com/thoughtbot/factory_girl), you can require your test factories and share the params. For example in FactoryGirl you can use the `attributes_for(:name_of_factory)` method.

### Missing Route Definitions Detection

Instead of manually finding out which route definitions you need, API Taster provides a warning page that shows you all the missing definitions.

![](http://i.imgur.com/vZb93.png)

### Obsolete / Mismatched Route Definitions Detection

APIs evolve - especially during the development stage. To keep `ApiTaster.routes` in sync with your route definitions, API Taster provides a warning page that shows you the definitions that are obsolete/mismatched therefore you could correct or remove them.

![](http://i.imgur.com/Fo7kQ.png)

### Use with an Engine

Rails Engines are largely self contained and separated from your main app. Therefore, to use API Taster with an Engine, you would need some extra efforts:

In your app Gemfile, you would also need:

```ruby
gem "jquery-rails"
gem "bootstrap-sass"
```

If you are hand-picking Rails components, make sure in your `application.rb` you have Sprockets enabled:

```ruby
require "sprockets/railtie"
```

## License

This gem is released under the [MIT License](http://www.opensource.org/licenses/mit-license.php).

## Author

[Fred Wu](https://github.com/fredwu), originally built for [Locomote](http://locomote.com.au).
