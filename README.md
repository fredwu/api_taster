# ApiTaster [![Build Status](https://secure.travis-ci.org/fredwu/api_taster.png?branch=master)](http://travis-ci.org/fredwu/api_taster) [![Dependency Status](https://gemnasium.com/fredwu/api_taster.png)](https://gemnasium.com/fredwu/api_taster)

A quick and easy way to visually test out your application's API.

![](http://i.imgur.com/1kyEk.png)

## Why?

There are already many awesome API clients (such as [Postman](https://chrome.google.com/webstore/detail/fdmmgilgnpjigdojojpjoooidkmcomcm)), so why reinvent the wheel?

API Taster compared to alternatives, have the following advantages:

- API endpoints are automatically generated from your Rails routes definition
- Defining post params is as easy as defining routes
- Post params can be shared with your test factories

## Usage

Add API Taster in your gemfile:

```ruby
gem 'api_taster'
```
Mount API Taster, this will allow you to visit API Taster from within your app. For example:

```ruby
Rails.application.routes.draw do
  mount ApiTaster::Engine => "/api_taster"
end
```

In `routes.rb`, define parameters for each API endpoint after the normal routes definition block. For example:

```ruby
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
```

That's it! Enjoy! :)

## License

This gem is released under the [MIT License](http://www.opensource.org/licenses/mit-license.php).

## Author

[Fred Wu](https://github.com/fredwu), originally built for [Locomote](http://locomote.com.au).
