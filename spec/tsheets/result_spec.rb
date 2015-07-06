require 'spec_helper'

describe TSheets::Result do
  def empty_messages
    JSON.dump({_status_extra: ''})
  end

  def error_message(msg = 'Something went wrong')
    JSON.dump({_status_extra: msg})
  end

  it 'has a success? method that returns true when api returns HTTP 200' do
    expect(TSheets::Result.new(200, empty_messages)).to respond_to(:success?)
    expect(TSheets::Result.new(200, empty_messages).success?).to be_truthy
    expect(TSheets::Result.new(417, error_message).success?).to be_falsy
  end

  it 'has an errors array' do
    errors = ['Erro1', 'Error2']
    data = JSON.dump({ _status_extra: errors })
    expect(TSheets::Result.new(417, data).errors).to eq(errors)
  end
end
