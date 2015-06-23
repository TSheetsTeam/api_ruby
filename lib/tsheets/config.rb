class TSheets::Config
  attr_accessor :access_token, :base_url, :adapter

  def initialize
    self.base_url ||= "https://rest.tsheets.com/api/v1"
    self.adapter ||= TSheets::RestAdapter
  end
end
