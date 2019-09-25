# ActiveFilters

Active Filters allows you to map incoming controller parameters to filter your resources by chaining scopes.

It is inspired by [Justin Weiss solution](https://www.justinweiss.com/articles/search-and-filter-rails-models-without-bloating-your-controller/) offering a cleaner way to declare your filters.

The gem [has_scope](https://github.com/plataformatec/has_scope) exists but does not handle params stored as the value of a hash.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'active_filters'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install active_filters

## Usage

Let's say you have several scopes on your User model

```ruby
class User < ApplicationRecord
    scope :country, -> country_code { where(country: country_code) }
    scope :gender, -> gender { where(gender: gender) }
end
```

And you want to chain thoses two scopes.
You first need to include the Filterable controller module in your application controller

```ruby
class ApplicationController < ActionController::Base
    include ActiveFilters::Controller::Filterable
end
```

and then include the model Filterable one in the model you want to filter.

```ruby
class User < ApplicationRecord
    include ActiveFilters::Model::Filterable

    scope :country, -> country_code { where(country: country_code) }
    scope :gender, -> gender { where(gender: gender) }
end
```

Then you just need to declare your named scopes as filters using the `has_filters` DSL

```ruby
class UsersController < ApplicationController
    has_filters :country, :gender
end
```

and apply them to a specific resource using the `filter` class method and the `filterable params` hash of params as argument.

```ruby
class UsersController < ApplicationController
    has_filters :country, :gender

    def index
        @users = User.with_filter(filterable_params)
    end
end
```

For each request:

```
/users
#=> acts like a normal request

/users?country=FR&gender=female
#=> calls the named scope and bring only females in France
```

Now let's say you want to use incoming params stored as the value of a hash as scopes:

```
/users?filter[country]=FR&filter[gender]=female
#=> { filter: { country: 'FR', gender: 'female' } }
```

Then you can add the `in_key` attribute with the name of the key in which params are stored.

```ruby
class UsersController < ApplicationController
    has_filters :country, :gender, in_key: :filter

    def index
        @users = User.filter(filterable_params)
    end
end
```

## Initializer

By default the params variable used by Active Filters is `params`.
If you want to use another params variable, you have to create an initializer in `config/initializers/active_filters.rb` and set the variable name: (for instance with @params)

```ruby
ActiveFilters::Setup.params_variable = '@params'
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/FidMe/active_filters.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
