require 'spec_helper'

describe TSheets::Repository do
  it 'takes a valid bridge at initialization' do
    expect { TSheets::Repository.new(nil) }.to raise_exception
    expect { TSheets::Repository.new(i) }.to raise_exception
    expect { TSheets::Repository.new(TSheets::Bridge.new) }.not_to raise_exception
  end
end

