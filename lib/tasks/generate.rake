require 'yaml'
require 'generator'

namespace :api do

  task :clean do
    TSheets::Generator.clean
  end

  desc "Generate dynamic parts of the API handlers"
  task :generate => [ :clean ] do
    config = YAML.load_file 'config/api.yml'
    TSheets::Generator.run! config
  end

end
