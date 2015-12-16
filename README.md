# Satisfy

Satisfy is a Description Language specification and execution engine. The Description Language can be considered a TDL (Test Description Language) or BDL (Business Description Language). These are the terms to indicate a language where elaborated requirements and tests become largely the same artifact.

Satisfy is an attempt to find a middle ground between my own [Specify](https://github.com/jnyman/specify) solution and my previous [Lucid](https://github.com/jnyman/lucid) solution. The latter was essentially a clone of Cucumber. The former relies entirely on RSpec. The goal of Satisfy is to satisfy (pun intended) my desire to explore a space between those two solutions.

Satisfy uses [Gherkin](https://github.com/cucumber/cucumber/wiki/Gherkin) to process test specifications similar to solutions like [Cucumber](http://cukes.info/) and [Spinach](https://github.com/codegram/spinach). In fact, Satisfy is almost a direct clone of [Turnip](https://github.com/jnicklas/turnip). Like Turnip -- but unlike Cucumber or Spinach -- Satisfy is designed to allow you to run Gherkin test specs through RSpec. This is in contrast to my aforementioned Specify tool, which allows you to construct test specs in code, rather than in separate test spec files. Those test specs are then also run via RSpec.

## Installation

To get the latest stable release, add this line to your application's Gemfile:

    gem 'satisfy'

To get the latest code:

```ruby
gem 'satisfy', git: https://github.com/jnyman/satisfy
```

After doing one of the above, execute the following command:

    $ bundle

You can also install Satisfy just as you would any other gem:

    $ gem install satisfy

## Usage

Satisfy uses RSpec as a test runner for executing Gherkin-style test specifications. Satisfy can run test specifications that have the extensions `.feature`, `.story`, or `.spec`. You can easily execute these tests by creating a `spec` directory that contains test specification files with those extensions and Gherkin scenarios. You can use any directory you want, of course, but if you use `spec` (the RSpec default), you don't have to tell Satisfy where to run.

Satisfy has to hook into the normal RSpec execution scheme in order to load the test specifications and execute them. The easiest way to do this is to create an `.rspec` file in your project directory with the following line:

```ruby
-r satisfy/rspec
```

Now add a test specification in your `spec` directory. Satisfy will check the `spec` directory as well as any subdirectories. So you can structure your test specification repository however you want. You can run the entire test repository of specifications simply by typing `rspec` (just as you would if using RSpec normally). However, you can run a single test spec as well. For example:

```
rspec spec/stardate/tng_stardates.spec
```

## Contributing

Bug reports and pull requests are welcome on GitHub at [https://github.com/jnyman/satisfy](https://github.com/jnyman/satisfy). The testing ecosystem of Ruby is very large and this project is intended to be a welcoming arena for collaboration on yet another testing tool. As such, contributors are very much welcome but are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

To contribute to Symbiont:

1. [Fork the project](http://gun.io/blog/how-to-github-fork-branch-and-pull-request/).
2. Create your feature branch. (`git checkout -b my-new-feature`)
3. Commit your changes. (`git commit -am 'new feature'`)
4. Push the branch. (`git push origin my-new-feature`)
5. Create a new [pull request](https://help.github.com/articles/using-pull-requests).

## Author

* [Jeff Nyman](http://testerstories.com)

## License

Satisfy is distributed under the [MIT](http://www.opensource.org/licenses/MIT) license.
See the [LICENSE](https://github.com/jnyman/satisfy/blob/master/LICENSE.txt) file for details.
