class TSheets::Result
  attr_accessor :code, :body

  def initialize(code, body)
    @code = code
    @body = body
  end

  def success?
    @code == 200
  end

  def data
    @_data ||= OpenStruct.new JSON.parse(@body)
  end

  def errors
    data._status_extra
  end
end
