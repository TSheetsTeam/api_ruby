require 'spec_helper'

describe TSheets::Model do
  it 'allows initialization without any arguments' do
    expect { ObjTypedModel.new }.not_to raise_exception(ArgumentError)
  end

  it 'allows initialization with a hash' do
    data = {
      name: "Testy Tester",
      created: "2004-02-12T15:19:21+00:00",
      born: "1986-01-15",
      active: true,
      endorsed: false,
      group_ids: [ 1, 2, 3, 4, 5, 6 ],
      tags: [ "awesome", "interesting", "beautiful" ],
      significant_dates: [ "1986-01-15", "2009-12-26" ],
      answers_path: [ true, false, false, true ]
    }
    object = ObjTypedModel.new data
    expect(object.name).to eq("Testy Tester")
    expect(object.created).to eq(DateTime.parse("2004-02-12T15:19:21+00:00"))
    expect(object.born).to eq(Date.parse("1986-01-15"))
    expect(object.active).to eq(true)
    expect(object.endorsed).to eq(false)
    expect(object.group_ids).to eq([ 1, 2, 3, 4, 5, 6 ])
    expect(object.tags).to eq([ "awesome", "interesting", "beautiful" ])
    expect(object.significant_dates).to eq([ "1986-01-15", "2009-12-26" ].map { |d| Date.parse(d) })
    expect(object.answers_path).to eq([ true, false, false, true ])
  end

  it 'shows dynamic fields too when inspecting' do
    data = {
      name: "Testy Tester",
      created: "2004-02-12T15:19:21+00:00",
      "idontexist" => true
    }
    object = ObjTypedModel.new data
    expect(object.inspect).to eq("<ObjTypedModel :id=>nil, :name=>\"Testy Tester\", :created=>#<DateTime: 2004-02-12T15:19:21+00:00 ((2453048j,55161s,0n),+0s,2299161j)>, :born=>nil, :active=>nil, :endorsed=>nil, :group_ids=>nil, :tags=>nil, :significant_dates=>nil, :answers_path=>nil, :idontexist=>true>")
  end

  it 'supports float field types' do
    expect { ObjModelWithFloat.new ratio: 2.76 }.not_to raise_exception
    expect(ObjModelWithFloat.new(ratio: 2.76).to_raw["ratio"]).to eq(2.76)
  end

  it 'supports object field types' do
    expect { ObjModelWithObject.new object: { "a": 1, "b": 2 } }.not_to raise_exception
    expect { ObjModelWithObject.new object: "" }.not_to raise_exception
    expect(ObjModelWithObject.new(object: "").object).to eq({})
    expect(ObjModelWithObject.new(object: "").to_raw["object"]).to eq("")
    expect(ObjModelWithObject.new(object: { "a": 1, "b": 2 }).to_raw["object"]).to eq({ "a": 1, "b": 2 })
  end

  describe 'from_raw class method' do
    it 'properly casts raw data into field types' do
      json = JSON.dump({
        id: 1,
        name: "Testy Tester",
        created: "2004-02-12T15:19:21+00:00",
        born: "1986-01-15",
        active: true,
        endorsed: false,
        group_ids: [ 1, 2, 3, 4, 5, 6 ],
        tags: [ "awesome", "interesting", "beautiful" ],
        significant_dates: [ "1986-01-15", "2009-12-26" ],
        answers_path: [ true, false, false, true ]
      })
      object = ObjTypedModel.from_raw(JSON.parse(json), {})
      expect(object.id).to eq(1)
      expect(object.name).to eq("Testy Tester")
      expect(object.created).to eq(DateTime.parse("2004-02-12T15:19:21+00:00"))
      expect(object.born).to eq(Date.parse("1986-01-15"))
      expect(object.active).to eq(true)
      expect(object.endorsed).to eq(false)
      expect(object.group_ids).to eq([ 1, 2, 3, 4, 5, 6 ])
      expect(object.tags).to eq([ "awesome", "interesting", "beautiful" ])
      expect(object.significant_dates).to eq([ "1986-01-15", "2009-12-26" ].map { |d| Date.parse(d) })
      expect(object.answers_path).to eq([ true, false, false, true ])
    end

    it 'allows models without any explicit fields given' do
      expect { EmptyObject.new onedate: "2004-02-12T15:19:21+00:00", otherdate: "2004-02-12T15:19:21+00:00" }.not_to raise_exception
    end

    it 'properly casts raw data into api defined objects' do
      json = JSON.dump({
        id: 1,
        name: "Testy Tester",
        group_id: 12,
        tag: {
          id: 122,
          name: "awesome"
        }
      })
      object = ObjTaggedModel.from_raw(JSON.parse(json), {})
      expect(object.id).to eq(1)
      expect(object.name).to eq("Testy Tester")
      expect(object.group_id).to eq(12)
      expect(object.tag).to be_an_instance_of(ObjTagModel)
      expect(object.tag.id).to eq(122)
      expect(object.tag.name).to eq("awesome")
    end

    it 'properly casts raw data into api defined objects when scoped by modules' do
      json = JSON.dump({
        id: 1,
        name: "Testy Tester",
        group_id: 12,
        tag: {
          id: 122,
          name: "awesome"
        }
      })
      object = ScopedObjects::ObjTaggedModel.from_raw(JSON.parse(json), {})
      expect(object.id).to eq(1)
      expect(object.name).to eq("Testy Tester")
      expect(object.group_id).to eq(12)
      expect(object.tag).to be_an_instance_of(ScopedObjects::ObjTagModel)
      expect(object.tag.id).to eq(122)
      expect(object.tag.name).to eq("awesome")
    end

    it 'handles nil values well' do
      json = JSON.dump({
        id: 1,
        name: "Testy Tester",
        created: nil,
        born: "1986-01-15",
        active: true,
        endorsed: false,
        group_ids: [ 1, 2, 3, 4, 5, 6 ],
        tags: [ "awesome", "interesting", "beautiful" ],
        significant_dates: [ "1986-01-15", "2009-12-26" ],
        answers_path: [ true, false, false, true ]
      })
      object = ObjTypedModel.from_raw(JSON.parse(json), {})
      expect(object.id).to eq(1)
      expect(object.name).to eq("Testy Tester")
      expect(object.created).to be_nil
      expect(object.born).to eq(Date.parse("1986-01-15"))
      expect(object.active).to eq(true)
      expect(object.endorsed).to eq(false)
      expect(object.group_ids).to eq([ 1, 2, 3, 4, 5, 6 ])
      expect(object.tags).to eq([ "awesome", "interesting", "beautiful" ])
      expect(object.significant_dates).to eq([ "1986-01-15", "2009-12-26" ].map { |d| Date.parse(d) })
      expect(object.answers_path).to eq([ true, false, false, true ])
      expect { object.to_raw }.not_to raise_exception
      expect(object.to_raw["created"]).to eq("")
    end

  end
end
