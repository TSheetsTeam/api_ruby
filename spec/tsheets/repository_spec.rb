require 'spec_helper'

describe TSheets::Repository do
  it 'takes a valid bridge at initialization' do
    expect { TSheets::Repository.new(nil) }.to raise_exception
  end

  describe 'where() method' do
    it 'exists' do
      repo = ObjRepo.new(fake_bridge)
      expect(repo).to respond_to(:where)
    end

    it 'returns a TSheets::Results instance' do
      repo = ObjRepo.new(fake_bridge)
      expect(repo.where(ids: [1, 2, 3]).class).to equal(TSheets::Results)
    end
  end

  describe 'all() method' do
    before(:each) do
      @repo = ObjRepo.new(fake_bridge)
    end
    it 'exists' do
      expect(@repo).to respond_to(:all)
    end

    it 'returns an instance of Array' do
      allow_any_instance_of(TSheets::Bridge).to receive(:next_batch).and_return({ items: [], has_more: false })
      expect(@repo.all).to be_an_instance_of(Array)
    end

    it 'acts as a shortcut to where({}).all' do
      expect_any_instance_of(TSheets::Results).to receive(:all).exactly(1).and_return([1,2,3])
      expect(@repo.all).to eq([1,2,3])
    end
  end
end

