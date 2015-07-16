class TSheets::HttpResponse
  attr_accessor :to_str, :code

  def initialize(response)
    @to_str = response.body
    @code = response.code
    
    puts @to_str if Typhoeus::Config.verbose
  end
end
