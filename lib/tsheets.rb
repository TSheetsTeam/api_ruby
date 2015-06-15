require "tsheets/version"

module TSheets
  require "tsheets/helpers"
  require "tsheets/model"
  require "tsheets/models"
  require "tsheets/repo"
  require "tsheets/repos"
  require "tsheets/results"
  require "tsheets/bridge"

  Dir["lib/tsheets/models/*.rb"].each {|file| require file.gsub('lib/', '') }
  Dir["lib/tsheets/repos/*.rb"].each {|file| require file.gsub('lib/', '') }

  require "tsheets/api"
end

