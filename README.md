# Database Transactions 💜 Capybara

You want your specs to use transactions for speed 🐎🐎🐎.

But as soon as you try it with Capybara, things go wrong 💻💥.

Don't flip tables.
Use this instead.

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


## Support ##

Right now this gem automatically fixes the following things:

 * ActiveRecord
 * jQuery
 * Angular

Don't see something you want?
I'd love a pull request, or even just a friendly inquiry!

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Think about how I'm a bad person for not writing any tests yet
6. Create new Pull Request

### Running the tests ###

```
cp spec/support/config.yml{.example,} # Edit as necessary
DB=sqlite rspec spec
```

You can run the specs with other databases as well, but you will have to create the databases and users manually first.
