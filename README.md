# Katagami

A toolkit for building Form object.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'katagami'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install katagami

## Examples

Katagami provides 3 way of form field definitions.

- Inherits attributes from an ActiveRecord model. (`fields_for`)
- Inherits spcific attributes from an ActiveRecord model. (`field` with a `for:` option)
- Define a field. (`field` with a Class as a field type)

### Inherits attributes from an ActiveRecord model. (`fields_for`)

`fields_for` inherits model attributes as form fields and these validators (excludes `id`, `created_at` and `updated_at`.)

```rb
class User < ActiveRecord::Base
  # User has attributes 'id', 'name', 'email', 'created_at', 'updated_at'
  validates :name, presence: true
end
```

```rb
class UserForm
  fields_for User
end

UserForm.field_names # => [:name, :email]
UserForm.validators[:name] # => [#<ActiveRecord::Validations::PresenceValidator:0x... @attributes=[:name], @options={}>]
```

fields_for provides `only` and `excludes` options.

```rb
class UserForm
  fields_for User, only: :name
end

UserForm.field_names # => [:name]
```

```rb
class UserForm
  fields_for User, excludes: :name
end

UserForm.field_names # => [:email]
```

### Inherits spcific attributes from an ActiveRecord model. (`field` with a `for:` option)

syntax sugar of `fields_for` with `only` option.

```rb
class UserForm
  field :name, :email, for: User
end
UserForm.field_names # => [:name, :email]
```

### Define a field. (`field` with a Class as a field type)

```rb
class UserForm
  field :password_confirm, String
end
```

TBD

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/hshimoyama/katagami.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
