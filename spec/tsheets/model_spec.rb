require 'spec_helper'

describe TSheets::Model do
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
  end
end
