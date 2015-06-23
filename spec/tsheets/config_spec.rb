require 'spec_helper'

describe TSheets::Config do
  it "has base_url always set after the initialization" do
    expect(TSheets::Config.new.base_url).not_to be_nil
  end

  it "has adapter always set after the initialization" do
    expect(TSheets::Config.new.adapter.new).to be_a_kind_of(TSheets::Adapter)
  end
end
