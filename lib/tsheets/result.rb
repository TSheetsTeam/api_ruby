class TSheets::Result
  attr_accessor :code, :body

  def initialize(code, body)
    @code = code
    @body = body
  end

  def success?
    @code == 200 && status_code == 200
  end

  def data
    @_data ||= OpenStruct.new JSON.parse(@body)
  end

  def status_code
    @_status_code ||= data.results.values.first.values.first["_status_code"] rescue 0
  end

  def message
    @_message ||= data.results.values.first.values.first["_status_extra"] rescue "Unexpected API response - inspect result body. Exception message: #{$!.message}"
  end
end
