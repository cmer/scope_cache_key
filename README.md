# Scope Cache Key

This gem adds the `cache_key` functionality to ActiveRecord scopes.

This is useful when caching a page that contains multiple records. It is now
possible to cache the entire page based on a scope. If any record in the scope
changes, the entire cache will be busted.

This should likely be used in a Russian Doll Caching scenario.

NOTE: This currently only works with Postgresql. Adding support for MySQL should
be trivial.

[![Build Status](https://secure.travis-ci.org/cmer/scope_cache_key.png?branch=master)](http://travis-ci.org/cmer/scope_cache_key)

## Installation

Add this line to your application's Gemfile:

    gem 'scope_cache_key', github: 'yonahforst/scope_cache_key'

## Usage

Example:

    <%
    scope = Article.page(1) # This should probably be done in your controller!
    cache scope do
      # logic to render and cache each article here
    end
    %>


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
