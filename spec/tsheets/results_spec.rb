require 'spec_helper'

describe TSheets::Results do
  before(:each) do
    @bridge = fake_bridge
    @repo = ObjRepo.new(@bridge)
  end

  it 'implements Enumerator' do
    expect(@repo.where(ids: [1, 2])).to respond_to(:each)
  end

  it 'only asks the bridge for new data in configurable batches' do
    results = @repo.where(ids: [1,2]) 
    allow(@bridge).to receive(:next_batch).exactly(4).times.and_return({ items: (1..2).to_a.map { |i| { id: i, name: "Name#{i}" }  }, has_more: false})
    results.each.lazy.take(8).to_a
  end

  it "yields results of a proper type" do
    results = @repo.where(ids: [1,2]) 
    allow(@bridge).to receive(:next_batch).and_return( { items: (1..2).to_a.map { |i| { id: i, name: "Name#{i}" }  }, has_more: false})
    results.each.lazy.take(2).each do |o|
      expect(o).to be_an_instance_of(ObjModel)
    end
  end

  describe 'all() and to_a() methods' do
    it 'exist' do
      results = @repo.where({})
      expect(results).to respond_to(:to_a)
      expect(results).to respond_to(:all)
    end

    it 'does exaclty the same' do
      results = @repo.where({})
      expect_any_instance_of(TSheets::Results).to receive(:all).and_return([])
      arr = results.to_a
      expect(arr).to eq([])
    end

    it 'returns all batches at once' do
      results = @repo.where({}) 
      responses = (1..4).to_a.map do |i|
        { 
          items: (1..4).to_a.map { |j| { id: ((i - 1) * 4 + j), name: "Name#{i*j}" }  },
          has_more: i != 4
        }
      end
      allow(@bridge).to receive(:next_batch).exactly(4).times.and_return(*responses)
      arr = results.all
      expect(arr.length).to eq(16)
      expect(arr.map(&:id)).to eq((1..16).to_a)
    end
  end

end

