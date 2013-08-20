DB_NAME = "scope_cache_key_test"
require 'rubygems'
require 'bundler/setup'

require 'active_record'
require 'action_controller'
require 'faker'
require 'rspec'
require 'pry'
require 'logger'
require "scope_cache_key"

Dir["#{Dir.pwd}/spec/support/**/*.rb"].each {|f| require f}

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.filter_run :focus

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = 'random'
end

def create_schema
  ActiveRecord::Migration.verbose = false

  ActiveRecord::Schema.define(:version => 0) do
    create_table :articles do |t|
      t.string :title
      t.text :body
      t.timestamps
    end

    create_table :comments do |t|
      t.references :article
      t.text :body
      t.string :user
      t.timestamps
    end
  end
end

class Article < ActiveRecord::Base
  has_many :comments
end

class Comment < ActiveRecord::Base
  belongs_to :article
end

class ApplicationController < ActionController::Base
end

def create_article(count = 1)
  count.times {
    Article.create! title: Faker::Lorem.sentence, body: Faker::Lorem.paragraphs(10)
  }
end

def create_comment(article, count = 1)
  count.times {
    Comment.create! user: Faker::Name.name, body: Faker::Lorem.paragraphs(10), article_id: article.id
  }
end


def configure_db(adapter, username = nil, password = nil)
  database = if adapter == "postgresql"
    "postgres"
  elsif ["mysql2", "mysql"].include?(adapter)
    "mysql"
  else
    ""
  end

  base_hash = { 'adapter' => adapter, 'database' => database }
  base_hash['username'] = username if username
  base_hash['password'] = password if password

  ActiveRecord::Base.configurations = { adapter => base_hash }
  ActiveRecord::Base.establish_connection(adapter)
  ActiveRecord::Base.connection.drop_database(DB_NAME) rescue nil
  ActiveRecord::Base.connection.create_database(DB_NAME)

  ActiveRecord::Base.configurations = { adapter => base_hash.merge('database' => DB_NAME) }
  ActiveRecord::Base.establish_connection(adapter)
  ActiveRecord::Base.logger = Logger.new(STDERR)
  ActiveRecord::Base.logger.level = Logger::WARN
end