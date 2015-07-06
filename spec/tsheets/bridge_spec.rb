require 'spec_helper'

describe TSheets::Bridge do

  it "conforms to the response JSON structure" do
    bridge = fake_bridge
    repo = ObjRepo.new(bridge, fake_cache)
    expect(TSheets::TestAdapter).to receive(:get) { 
      OpenStruct.new({
        code: 200,
        to_str:
          <<-EOF
            {
              "results": {
                "obj_models": {
                  "1": {
                      "id": 1,
                      "name": "Name1",
                      "group_id": 1
                    },
                  "2": {
                      "id": 2,
                      "name": "Name2",
                      "group_id": 2
                    }
              },
              "more": false,
              "supplemental_data": {
                "groups": {
                "1": {
                    "id": 1,
                    "name": "test1"
                  },
                "2": {
                    "id": 2,
                    "name": "test2"
                  }
                }
              }
            }
            }
          EOF
      })
    }
    objs = repo.where(ids: [1,2]).each.lazy.take(4)
    expect(objs.count).to eq(2)
  end

 it "fetching mechanism uses an info about the availability of more data" do
    bridge = fake_bridge
    repo = ObjRepo.new(bridge, fake_cache)
    i = 0
    expect(TSheets::TestAdapter).to receive(:get).at_least(1) { 
      OpenStruct.new({
        code: 200,
        to_str:
          <<-EOF
            {
              "results": {
                "obj_models": {
                  "1": {
                      "id": 1,
                      "name": "Name1",
                      "group_id": 1
                    },
                  "2": {
                      "id": 2,
                      "name": "Name2",
                      "group_id": 2
                    }
                }
              },
              "more": #{ (i += 1) != 4 },
              "supplemental_data": {
                "obj_group_models": {
                  "1": {
                      "id": 1,
                      "name": "test1"
                    },
                  "2": {
                      "id": 2,
                      "name": "test2"
                    }
                }
              }
            }
          EOF
      })
    }
    objs = repo.where(ids: [1,2]).each.lazy.take(10)
    expect(objs.count).to eq(8)
 end

 it 'handles the case of no results properly' do
    bridge = fake_bridge
    repo = ObjRepo.new(bridge, fake_cache)
    expect(TSheets::TestAdapter).to receive(:get) { 
      OpenStruct.new({
        code: 200,
        to_str:
          <<-EOF
            {
              "results": {
                "obj_models": [],
              "more": false,
              "supplemental_data": {
              }
            }
            }
          EOF
      })
    }
    objs = repo.where(ids: [1,2]).all
    expect(objs.count).to eq(0)
 end

end
