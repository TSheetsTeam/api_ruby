class TSheets::Bridge
  def initialize(config)
    @_config = config
  end

  def access_token
    @_config[:access_token]
  end

  def base_url
    @_config[:base_url] || "https://rest.tsheets.com/api/v1"
  end

  def get(model, url, options)
    TSheets::Results.new "#{base_url}#{url}", options, { Authorization: "Bearer: #{self.access_token}" }, model
  end
end
