require 'spec_helper'

describe TSheets::Repository do
  it 'takes a valid bridge at initialization' do
    expect { TSheets::Repository.new(nil) }.to raise_exception(ArgumentError)
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

    it 'throws an exception for repos not having :list in their actions' do
      allow_any_instance_of(TSheets::Bridge).to receive(:next_batch).and_return(
        { 
          items: (1..4).to_a.map { |j| { id: j, name: "Name#{j}" }  },
          has_more: false
        }
      )
      repo = ScopedObjects::ObjRepo3.new(fake_bridge)
      repo2 = ObjRepo.new(fake_bridge)
      expect { repo.where({}) }.to raise_exception(TSheets::MethodNotAvailableError)
      expect { repo.all }.to raise_exception(TSheets::MethodNotAvailableError)
      expect { repo2.where({}) }.not_to raise_exception
      expect { repo2.all }.not_to raise_exception
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

