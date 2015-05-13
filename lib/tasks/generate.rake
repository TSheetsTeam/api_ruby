require 'yaml'
require 'generator'

namespace :api do

  task :clean do
    Generator.clean
  end

  desc "Generate dynamic parts of the API handlers"
  task :generate => [ :clean ] do
    config = YAML.load_file 'config/api.yml'
    Generator.run! config
  end

end
