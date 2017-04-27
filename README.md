# Database Transactions 💜 Capybara

[![Build Status]](https://travis-ci.org/iangreenleaf/transactional_capybara)

You want your specs to use transactions for speed 🐎🐎🐎

But as soon as you try it with Capybara, things go wrong 💻💥

Don't flip tables.
Use this instead.

For a detailed explanation of how this works, refer to the [introductory blog post].

## Support ##

Right now this gem automatically handles the following things:

 * ActiveRecord
 * Sequel
 * jQuery
 * Angular

Tested on Capybara 2.4.x, may not work on other major versions.

Don't see something you want?
I'd love a pull request, or even just a friendly inquiry!

## Setup ##

Add it to your Gemfile, of course:

```ruby
group :test do
  gem 'transactional_capybara'
end
```

And then initialize it in your tests…

### RSpec ###

In `rails_helper.rb` (or `spec_helper.rb`):

```ruby
require "transactional_capybara/rspec"
```

If you're using ActiveRecord::Base.maintain_test_schema! in you rails_helper.rb (or spec_helper.rb), make sure it is invoked before requiring transactional_capybara. Failure to do so might cause some non-deterministic connection failures.

Your database connection is automatically shared between threads, and all specs tagged with `js: true` will wait for AJAX requests to finish before continuing.

Wow. Much convenience. So relax.

### All other test frameworks ###

Somewhere near the beginning of your test initialization:

```ruby
TransactionalCapybara.share_connection
```

And then make sure to define a hook that will run after each Capybara test:

```ruby
after :each do
  TransactionalCapybara::AjaxHelpers.wait_for_ajax(page)
end
```

## Manually waiting for AJAX ##

You might have situations where you need to wait for AJAX calls to complete at times other than teardown.
For example, you might have a pattern like this if you access models directly for either setup or verification of results:

```ruby
visit "/page-that-fires-ajax"
Model.where(whatever).first
```

This can still fail!
The ideal solution is to avoid direct database manipulation in integration tests.
However, if you insist on doing this, you can stay safe by waiting for AJAX to complete before continuing:

```ruby
visit "/page-that-fires-ajax"
TransactionalCapybara::AjaxHelpers.wait_for_ajax(page)
Model.where(whatever).first
```

If you'd like the helper more easily accessible, just mix the `AjaxHelpers` module into your test suite.
In RSpec, you can do this in the config block:

```ruby
RSpec.configure do |config|
  config.include TransactionalCapybara::AjaxHelpers
end
```
Or in any example group:

```ruby
describe "awesome web stuff" do
  include TransactionalCapybara::AjaxHelpers
end
```

Now the helper is easily available:

```ruby
visit "/page-that-fires-ajax"
wait_for_ajax
Model.where(whatever).first
```

## DatabaseCleaner ##

For this gem to be able to help with AJAX, it needs to be invoked *before* DatabaseCleaner rolls back the transaction.

You should be good to go if your setup looks like this:

```ruby
config.around(:each) do |example|
  DatabaseCleaner.cleaning do
    example.run
  end
end
```

But if you're using before/after hooks to clean, like:

```ruby
before :each do
  DatabaseCleaner.start
end

after :each do
  DatabaseCleaner.clean
end
```

Then you need to make sure the AJAX hook runs first.
Declare it before the DatabaseCleaner code and you should be set:

```ruby
after :each do
  TransactionalCapybara::AjaxHelpers.wait_for_ajax(page)
end

before :each do
  DatabaseCleaner.start
end

after :each do
  DatabaseCleaner.clean
end
```

## Sequel ##
If you want to have shared database connections with sequel just
add the option `single_threaded: true` to your sequel connection in test.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Make your changes. Don't forget to add a test!
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
6. Create new Pull Request

### Running the tests ###

```
cp spec/support/config.yml{.example,} # Edit as necessary
DB=sqlite rspec spec
```

You can run the specs with other databases as well, but you will have to create the databases and users manually first.

[Build Status]: https://travis-ci.org/iangreenleaf/transactional_capybara.svg?branch=master
[introductory blog post]: http://technotes.iangreenleaf.com/posts/the-one-true-guide-to-database-transactions-with-capybara.html
