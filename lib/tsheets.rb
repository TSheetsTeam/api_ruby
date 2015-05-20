require "tsheets/version"

module TSheets
  require "tsheets/model"
  require "tsheets/models"
  Dir["lib/tsheets/models/*.rb"].each {|file| require file.gsub('lib/', '') }
end

