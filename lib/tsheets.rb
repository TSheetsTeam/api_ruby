require "tsheets/version"

module TSheets
  require "tsheets/model"
  require "tsheets/models"
  require "tsheets/repo"
  require "tsheets/repos"

  Dir["lib/tsheets/models/*.rb"].each {|file| require file.gsub('lib/', '') }
  Dir["lib/tsheets/repos/*.rb"].each {|file| require file.gsub('lib/', '') }

  require "tsheets/api"
end

