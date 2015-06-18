require 'spec_helper'

describe TSheets::Results do
  it 'implements Enumerator' do
    repo = ObjRepo.new(fake_bridge)
    expect(repo.where(ids: [1, 2])).to respond_to(:each)
  end

  it 'only asks the bridge for new data in configurable batches' do
    bridge = fake_bridge
    repo = ObjRepo.new(bridge)
    results = repo.where(ids: [1,2]) 
    allow(results).to receive(:next_batch).exactly(4).times.and_return((1..2).to_a.map { |i| { id: i, name: "Name#{i}" }  })
    results.each.lazy.take(8).map { |i| puts "--> #{i}" }.to_a
  end
end

