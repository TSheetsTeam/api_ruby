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

    context 'properly uses given filters' do
      it 'sends given filters with values as params' do
        repo = ObjTypedRepo.new(fake_bridge) 
        params = { ids: [1, 2, 3], name: 'Hello', born: true, endorsed: false, tags: [ 'cool', 'unique' ], significant_dates: [ DateTime.now.to_date, Date.parse("1900-01-01") ] }
        expect(TSheets::TestAdapter).to receive(:get).with(anything(), hash_including({params: params})).and_return(OpenStruct.new({ code: 200, to_str: { results: { obj_typed_models: {} }, more: false }.to_json }))
        repo.where(params).all
      end

      it 'throws an exception when given filter does not exist' do
        repo = ObjTypedRepo.new(fake_bridge) 
        params = { idontexist: [1, 2, 3], name: 'Hello', born: true, endorsed: false, tags: [ 'cool', 'unique' ], significant_dates: [ DateTime.now.to_date, Date.parse("1900-01-01") ] }
        expect { repo.where(params).all }.to raise_exception(TSheets::FilterNotAvailableError)
      end

      it 'throws an exception when given filter accepts a different type of data' do
        repo = ObjTypedRepo.new(fake_bridge) 
        params = { ids: [ 1 ], name: 'Hello', born: true, endorsed: false, tags: [ 'cool', 'unique' ], significant_dates: [ DateTime.now.to_date, "1900-01-01" ] }
        expect { repo.where(params).all }.to raise_exception(TSheets::FilterValueInvalidError)
      end
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

