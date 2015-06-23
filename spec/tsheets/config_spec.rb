require 'spec_helper'

describe TSheets::Config do
  it "has base_url always set after the initialization" do
    expect(TSheets::Config.new.base_url).not_to be_nil
  end
end
