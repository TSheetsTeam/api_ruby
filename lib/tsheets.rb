require "tsheets/version"

if RUBY_VERSION.split('.').first.to_i < 2
  require 'backports/2.0.0/enumerable/lazy' 
  require 'ostruct'
end

module TSheets
  require "tsheets/errors"
  require "tsheets/helpers"
  require "tsheets/config"
  require "tsheets/http_response"
  require "tsheets/adapter"
  require "tsheets/rest_adapter"
  require "tsheets/model"
  require "tsheets/models"
  require "tsheets/repository"
  require "tsheets/repos"
  require "tsheets/result"
  require "tsheets/results"
  require "tsheets/supplemental_cache"
  require "tsheets/bridge"

  base_dir = File.dirname(__FILE__)
  Dir[File.join(base_dir, "tsheets", "models", "*.rb")].each { |file| require file }
  Dir[File.join(base_dir, "tsheets", "repos", "*.rb")].each  { |file| require file }

  require "tsheets/api"
end

