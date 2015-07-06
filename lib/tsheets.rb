require "tsheets/version"
require 'pry'

module TSheets
  require "tsheets/errors"
  require "tsheets/helpers"
  require "tsheets/config"
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

  Dir["lib/tsheets/models/*.rb"].each {|file| require file.gsub('lib/', '') }
  Dir["lib/tsheets/repos/*.rb"].each {|file| require file.gsub('lib/', '') }

  require "tsheets/api"
end

