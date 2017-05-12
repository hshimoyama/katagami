require "bundler/setup"
require "pry"
require "pry-byebug"
require "mysql2"
require "active_record"
require "katagami"

db_config = YAML.load_file('config/database.yml')["test"]
ActiveRecord::Base.establish_connection db_config

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
