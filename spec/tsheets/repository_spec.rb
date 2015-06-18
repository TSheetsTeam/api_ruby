require 'spec_helper'

describe TSheets::Repository do
  it 'takes a valid bridge at initialization' do
    expect { TSheets::Repository.new(nil) }.to raise_exception
  end

  describe 'where() method' do
    it 'returns a TSheets::Results instance' do
      repo = ObjRepo.new(fake_bridge)
      expect(repo.where(ids: [1, 2, 3]).class).to equal(TSheets::Results)
    end
  end
end

