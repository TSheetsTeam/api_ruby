require 'spec_helper'

describe TSheets::Adapter do
  it 'responds to :post' do
    expect(TSheets::Adapter).to respond_to(:post)
  end

  it 'responds to :put' do
    expect(TSheets::Adapter).to respond_to(:put)
  end

  it 'responds to :get' do
    expect(TSheets::Adapter).to respond_to(:get)
  end

  it 'responds to :delete' do
    expect(TSheets::Adapter).to respond_to(:delete)
  end
end
