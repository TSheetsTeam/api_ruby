class TSheets::HttpResponse
  attr_accessor :to_str, :code

  def initialize(response)
    @to_str = response.body
    @code = response.code
  end
end
