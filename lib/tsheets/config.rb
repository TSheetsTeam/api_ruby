class TSheets::Config
  attr_accessor :access_token, :base_url

  def initialize
    self.base_url ||= "https://rest.tsheets.com/api/v1"
  end
end
