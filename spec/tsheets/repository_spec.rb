require 'spec_helper'

describe TSheets::Repository do
  it 'takes a valid bridge at initialization' do
    expect { TSheets::Repository.new(nil) }.to raise_exception
  end
end

