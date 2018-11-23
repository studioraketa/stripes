# Stripes
In Raketa we have a few project sharing Stripe payment methods, including the usage of the webhooks
supported by Stripe and we needed a way to share the code and webhooks between all those projects.
This is our humble solution to that task.

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'stripes', path: '../../raketa/stripes/'
```

And then execute:
```bash
$ bundle
```

### Prepare an initializer
In order to use the engine you will need to configure it:
```ruby
module Stripes
  Configuration.configure do |config|
    config.order_class = ::Order
    config.order_table_foreign_key = :order_id
    config.http_basic_auth_user = 'user'
    config.http_basic_auth_password = 'secret'
    config.stripe_public_key = ENV.fetch('PUBLISHABLE_KEY')
    config.stripe_private_key = ENV.fetch('SECRET_KEY')
  end
end
```
The main application needs to have a model Order (or a different name) and it needs to pass in the
class of it and the foreign key. Check the migrations section for more information on linking the
engine and the main app's Order model and table.

### Install and add required migrations
Run the following command:
```shell
bin/rails stripes:install:migrations
```
After the migrations are installed check from which version of rails are they created since the
installed migrations will have the version with which the engine was developed last (5.1).

Then execute the migrations
```shell
bin/rails db:migrate
```

In the initializer you are required to setup a order class which will be used by the engine.
The main application needs to add a migration to the engine payments table (stripes_payments):
```ruby
def change
  add_reference :stripes_payments, :order, foreign_key: { on_delete: :restrict }
end
```

### Linking the Stripes::Payment and the main application Order model
In the main application's Order the relation should be declared. For example:
```ruby
has_one :payment, class_name: 'Stripes::Payment', foreign_key: :order_id
```

## Usage

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).


## TBD
- Documentation and Usage instructions
