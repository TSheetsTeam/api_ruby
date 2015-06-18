require "tsheets/version"
require 'pry'

module TSheets
  require "tsheets/helpers"
  require "tsheets/config"
  require "tsheets/model"
  require "tsheets/models"
  require "tsheets/repository"
  require "tsheets/repos"
  require "tsheets/results"
  require "tsheets/bridge"

  Dir["lib/tsheets/models/*.rb"].each {|file| require file.gsub('lib/', '') }
  Dir["lib/tsheets/repos/*.rb"].each {|file| require file.gsub('lib/', '') }

  require "tsheets/api"
end

