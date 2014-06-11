# ApiTaster [![endorse](http://api.coderwall.com/fredwu/endorsecount.png)](http://coderwall.com/fredwu) [![Build Status](https://secure.travis-ci.org/fredwu/api_taster.png?branch=master)](http://travis-ci.org/fredwu/api_taster) [![Dependency Status](https://gemnasium.com/fredwu/api_taster.png)](https://gemnasium.com/fredwu/api_taster)

### NOTE
> If you want to use this gem with Rails 3x/4.0 please specify version 0.7.0 in
your Gemfile.

> Version 0.8 of this gem is compatible only with Rails 4.1.

A quick and easy way to visually test your Rails application's API.

![](http://i.imgur.com/8Dnto.png)

## Why?

There are already many awesome API clients (such as [Postman](https://chrome.google.com/webstore/detail/fdmmgilgnpjigdojojpjoooidkmcomcm)), so why reinvent the wheel?

API Taster compared to alternatives, have the following advantages:

- API endpoints are automatically generated from your Rails routes definition
- Defining params is as easy as defining routes
- Params can be shared with your test factories

## Usage

Add API Taster in your gemfile:

```ruby
gem 'api_taster'
```
Mount API Taster, this will allow you to visit API Taster from within your app. For example:

```ruby
Rails.application.routes.draw do
  mount ApiTaster::Engine => "/api_taster" if Rails.env.development?
end
```

In `lib/api_tasters/routes.rb`, define parameters for each API endpoint after the normal routes definition block. For example:

```ruby
if Rails.env.development?
  ApiTaster.routes do
    desc 'Get a __list__ of users'
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

You can change the default `lib/api_tasters/routes.rb` path by creating `config/initializers/api_taster.rb` with the content below:
```ruby
ApiTaster.route_path = Rails.root.to_s + "/app/api_tasters" # just an example
```

### Share Params with Test Factories

If you use a test factory such as [FactoryGirl](https://github.com/thoughtbot/factory_girl), you can require your test factories and share the params. For example in FactoryGirl you can use the `attributes_for(:name_of_factory)` method.

### Custom Headers

If there are certain headers (such as auth token) that need to be present to
consume an API endpoint, you may set then in `APITaster.global_headers` before
`APITaster.routes`:

```ruby
ApiTaster.global_headers = {
  'Authorization' => 'Token token=teGpfbVitpnUwm7qStf9'
}

ApiTaster.routes do
  # your route definitions
end
```

### Global Params

If there are certain params (such as API version and auth token) that need to be present in every API endpoint, you may set them in `ApiTaster.global_params` before `ApiTaster.routes`:

```ruby
ApiTaster.global_params = {
  :version    => 1,
  :auth_token => 'teGpfbVitpnUwm7qStf9'
}

ApiTaster.routes do
  # your route definitions
end
```

### Commenting API Endpoints

Before each route definitions, you may use `desc` to add some comments. Markdown is supported.

```ruby
desc 'Get a __list__ of users'
get '/users'
```

### Metadata for API Endpoints

For each route definition, you may supply an optional third parameter (hash) as metadata:

```ruby
get '/users', {}, { :meta => 'data' }
```

The metadata option is useful for passing in arbitrary data for a route definition. For example, you could specify response expectations so that your test suite could tap into them.

Metadata for every route definition are stored in `ApiTaster::Route.metadata`. Please read the source code to find out how to get metadata for a particular route.

### Missing Route Definitions Detection

Instead of manually finding out which route definitions you need, API Taster provides a warning page that shows you all the missing definitions.

![](http://i.imgur.com/vZb93.png)

### Obsolete / Mismatched Route Definitions Detection

APIs evolve - especially during the development stage. To keep `ApiTaster.routes` in sync with your route definitions, API Taster provides a warning page that shows you the definitions that are obsolete/mismatched therefore you could correct or remove them.

![](http://i.imgur.com/qK7g5.png)

## License

This gem is released under the [MIT License](http://www.opensource.org/licenses/mit-license.php).

## Author

[Fred Wu](https://github.com/fredwu), originally built for [Locomote](http://locomote.com.au).


[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/fredwu/api_taster/trend.png)](https://bitdeli.com/free "Bitdeli Badge")

