source 'https://rubygems.org'

# Specify your gem's dependencies in scope_cache_key.gemspec
gemspec

# With the help of https://github.com/sferik/rails_admin/blob/master/Gemfile
platforms :jruby do
  gem 'activerecord-jdbcpostgresql-adapter', '>= 1.2'
  gem 'jdbc-postgres', '>= 9.2'
  gem "jdbc-mysql"
end

platforms :ruby, :mswin, :mingw do
  gem 'pg'
  gem "mysql2"
end
