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
    allow(bridge).to receive(:next_batch).exactly(4).times.and_return((1..2).to_a.map { |i| { id: i, name: "Name#{i}" }  })
    results.each.lazy.take(8).to_a
  end

  it "yields results of a proper type" do
    bridge = fake_bridge
    repo = ObjRepo.new(bridge)
    results = repo.where(ids: [1,2]) 
    allow(bridge).to receive(:next_batch).and_return((1..2).to_a.map { |i| { id: i, name: "Name#{i}" }  })
    results.each.lazy.take(2).each do |o|
      expect(o).to be_an_instance_of(ObjModel)
    end
  end
end

