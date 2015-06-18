require 'spec_helper'

describe TSheets::API do
  it 'takes a block in the initializer injecting the config' do
    TSheets::API.new do |config|
      expect(config).to be_an_instance_of(TSheets::Config)
      expect { config.access_token }.not_to raise_exception
      expect { config.base_url }.not_to raise_exception
    end
  end
end
