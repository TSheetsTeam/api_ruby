require 'spec_helper'

describe TSheets::Result do
  def empty_messages
    <<-EOF
{
 "results": {
  "timesheets": {
   "1": {
    "_status_code": 200
   }
  }
 }
}
    EOF
  end

  def error_message
    <<-EOF
{
 "results": {
  "timesheets": {
   "1": {
    "_status_code": 417,
    "_status_message": "Expectation Failed",
    "_status_extra": "Invalid params: locked,on_the_clock,tz,tz_str,location"
   }
  }
 }
}
    EOF
  end

  describe "success? method" do
    it 'returns true when api returns HTTP 200' do
      expect(TSheets::Result.new(200, empty_messages)).to respond_to(:success?)
      expect(TSheets::Result.new(200, empty_messages).success?).to be_truthy
      expect(TSheets::Result.new(417, error_message).success?).to be_falsy
    end

    it 'returns false when HTTP 200 but errors found in the body' do
      expect(TSheets::Result.new(200, error_message).success?).to be_falsy
    end
  end

  describe "message method" do
    it 'exists' do
      errors = "Invalid params: locked,on_the_clock,tz,tz_str,location"
      expect(TSheets::Result.new(417, error_message).message).to eq(errors)
    end
  end
end
