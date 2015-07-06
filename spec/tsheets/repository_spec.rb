require 'spec_helper'

describe TSheets::Repository do
  it 'takes a valid bridge at initialization' do
    expect { TSheets::Repository.new(nil, fake_cache) }.to raise_exception(ArgumentError)
  end

  describe 'where() method' do
    it 'exists' do
      repo = ObjRepo.new(fake_bridge, fake_cache)
      expect(repo).to respond_to(:where)
    end

    it 'returns a TSheets::Results instance' do
      repo = ObjRepo.new(fake_bridge, fake_cache)
      expect(repo.where(ids: [1, 2, 3]).class).to equal(TSheets::Results)
    end

    it 'throws an exception for repos not having :list in their actions' do
      allow_any_instance_of(TSheets::Bridge).to receive(:next_batch).and_return(
        { 
          items: (1..4).to_a.map { |j| { id: j, name: "Name#{j}" }  },
          has_more: false
        }
      )
      repo = ScopedObjects::ObjRepo3.new(fake_bridge, fake_cache)
      repo2 = ObjRepo.new(fake_bridge, fake_cache)
      expect { repo.where({}) }.to raise_exception(TSheets::MethodNotAvailableError)
      expect { repo.all }.to raise_exception(TSheets::MethodNotAvailableError)
      expect { repo2.where({}) }.not_to raise_exception
      expect { repo2.all }.not_to raise_exception
    end

    context 'properly uses given filters' do
      it 'sends given filters with values as params' do
        repo = ObjTypedRepo.new(fake_bridge, fake_cache) 
        params = { ids: [1, 2, 3], name: 'Hello', born: true, endorsed: false, tags: [ 'cool', 'unique' ], significant_dates: [ DateTime.now.to_date, Date.parse("1900-01-01") ] }
        expect(TSheets::TestAdapter).to receive(:get).with(anything(), hash_including({params: params})).and_return(OpenStruct.new({ code: 200, to_str: { results: { obj_typed_models: {} }, more: false }.to_json }))
        repo.where(params).all
      end

      it 'throws an exception when given filter does not exist' do
        repo = ObjTypedRepo.new(fake_bridge, fake_cache) 
        params = { idontexist: [1, 2, 3], name: 'Hello', born: true, endorsed: false, tags: [ 'cool', 'unique' ], significant_dates: [ DateTime.now.to_date, Date.parse("1900-01-01") ] }
        expect { repo.where(params).all }.to raise_exception(TSheets::FilterNotAvailableError)
      end

      it 'throws an exception when given filter accepts a different type of data' do
        repo = ObjTypedRepo.new(fake_bridge, fake_cache) 
        params = { ids: [ 1 ], name: 'Hello', born: true, endorsed: false, tags: [ 'cool', 'unique' ], significant_dates: [ DateTime.now.to_date, "1900-01-01" ] }
        expect { repo.where(params).all }.to raise_exception(TSheets::FilterValueInvalidError)
      end
    end

    context 'storing of supplemental data' do
      it 'makes the supplemental data available as instances of correct classes accessed by fields' do
        repo = ObjRepo.new(fake_bridge, fake_cache)
        expect(TSheets::TestAdapter).to receive(:get).and_return(OpenStruct.new({
          code: 200,
          to_str: { 
            results: {
              obj_models: {
                '1' => {
                  id: 1,
                  name: 'Name1',
                  group_id: 1
                },
                '2' => {
                  id: 2,
                  name: 'Name2',
                  group_id: 2
                },
                '3' => {
                  id: 3,
                  name: 'Name3',
                  group_id: 2
                },
                '4' => {
                  id: 4,
                  name: 'Name4',
                  group_id: 1
                }
              } 
            }, 
            more: false,
            supplemental_data: {
              obj_group_models: {
                '1' => {
                  id: 1,
                  name: 'Group1'
                },
                '2' => {
                  id: 2,
                  name: 'Group2'
                }
              }
            }
          }.to_json 
        }))
        results = repo.where({}).all
        results.each do |obj|
          expect(obj.group).to be_an_instance_of(ObjGroupModel)
          expect(obj.group.name).to eq("Group#{obj.group.id}")
        end
      end

      it 'caches supplemental data' do
        repo = ObjRepo.new(fake_bridge, fake_cache)
        expect(TSheets::TestAdapter).to receive(:get).and_return(OpenStruct.new({
          code: 200,
          to_str: { 
            results: {
              obj_models: {
                '1' => {
                  id: 1,
                  name: 'Name1',
                  group_id: 1
                },
                '2' => {
                  id: 2,
                  name: 'Name2',
                  group_id: 2
                },
                '3' => {
                  id: 3,
                  name: 'Name3',
                  group_id: 2
                },
                '4' => {
                  id: 4,
                  name: 'Name4',
                  group_id: 1
                }
              } 
            }, 
            more: true,
            supplemental_data: {
              obj_group_models: {
                '1' => {
                  id: 1,
                  name: 'Group1'
                },
                '2' => {
                  id: 2,
                  name: 'Group2'
                }
              }
            }
          }.to_json 
        }), OpenStruct.new({
          code: 200,
          to_str: { 
            results: {
              obj_models: {
                '5' => {
                  id: 5,
                  name: 'Name5',
                  group_id: 1
                },
                '6' => {
                  id: 6,
                  name: 'Name6',
                  group_id: 2
                },
                '7' => {
                  id: 7,
                  name: 'Name7',
                  group_id: 2
                },
                '8' => {
                  id: 8,
                  name: 'Name8',
                  group_id: 1
                }
              } 
            }, 
            more: false
          }.to_json 
        }))
        results = repo.all
        expect(results.count).to eq(8)
        results.each do |obj|
          expect(obj.group).to be_an_instance_of(ObjGroupModel)
          expect(obj.group.name).to eq("Group#{obj.group.id}")
        end
      end
    end
  end

  describe 'all() method' do
    before(:each) do
      @repo = ObjRepo.new(fake_bridge, fake_cache)
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

  describe 'update() method' do
    before(:each) do
      @cache = fake_cache
      @repo = ObjExtTypedRepo.new(fake_bridge, @cache)
    end

    it 'makes a put request with a payload of a proper format' do
      obj = {
        'id' => 1,
        'name' => "Name1",
        'created' => '2004-02-12T15:19:21+00:00',
        'born' => '2012-11-11',
        'active' => true,
        'endorsed' => false,
        'group_ids' => [ 1, 6, 9 ],
        'tags' => [ 'hey', 'hi', 'hello' ],
        'significant_dates' => [ '2012-01-01', '2012-01-02' ],
        'answers_path' => [ true, false, true ],
        'extended' => {
          'id' => 44,
          'whoami' => '...'
        }
      }
      data = {
        'data' => [
          obj
        ]
      }
      expect(TSheets::TestAdapter).to receive(:put).with('https://rest.tsheets.com/api/v1/ext_typed_objects', data, anything()).and_return(OpenStruct.new({code: 200, to_str: JSON.dump({obj_ext_typed_models: [ obj.merge({_status_message: 'Updated'}) ]})}))
      model = ObjExtTypedModel.from_raw(data['data'].first, @cache)
      @repo.update(model)
    end
  end

  describe 'insert() method' do
    before(:each) do
      @cache = fake_cache
      @repo = ObjExtTypedRepo.new(fake_bridge, @cache)
    end

    it 'makes a post request with a payload of a proper format' do
      data = {
        'data' => [
          {
            'id' => 1,
            'name' => "Name1",
            'created' => '2004-02-12T15:19:21+00:00',
            'born' => '2012-11-11',
            'active' => true,
            'endorsed' => false,
            'group_ids' => [ 1, 6, 9 ],
            'tags' => [ 'hey', 'hi', 'hello' ],
            'significant_dates' => [ '2012-01-01', '2012-01-02' ],
            'answers_path' => [ true, false, true ],
            'extended' => {
              'id' => 44,
              'whoami' => '...'
            }
          }
        ]
      }
      expect(TSheets::TestAdapter).to receive(:post).with('https://rest.tsheets.com/api/v1/ext_typed_objects', data, anything()).and_return(OpenStruct.new({code: 200, to_str: JSON.dump({_status_extra: ''})}))
      model = ObjExtTypedModel.from_raw(data['data'].first, @cache)
      @repo.insert(model)
    end

    it 'is only available for repos with :add in methods' do
      @repo = ObjExtTypedRepo2.new(fake_bridge, @cache)
      data = {
        'data' => [
          {
            'id' => 1,
            'name' => "Name1",
            'created' => '2004-02-12T15:19:21+00:00',
            'born' => '2012-11-11',
            'active' => true,
            'endorsed' => false,
            'group_ids' => [ 1, 6, 9 ],
            'tags' => [ 'hey', 'hi', 'hello' ],
            'significant_dates' => [ '2012-01-01', '2012-01-02' ],
            'answers_path' => [ true, false, true ],
            'extended' => {
              'id' => 44,
              'whoami' => '...'
            }
          }
        ]
      }
      expect(TSheets::TestAdapter).not_to receive(:post).with('https://rest.tsheets.com/api/v1/ext_typed_objects', data, anything())
      model = ObjExtTypedModel.from_raw(data['data'].first, @cache)
      expect { @repo.insert(model) }.to raise_exception(TSheets::MethodNotAvailableError)
    end

    it 'returns a proper instance of the result class' do
      @repo = ObjExtTypedRepo.new(fake_bridge, @cache)
      data = {
        'data' => [
          {
            'id' => 1,
            'name' => "Name1",
            'created' => '2004-02-12T15:19:21+00:00',
            'born' => '2012-11-11',
            'active' => true,
            'endorsed' => false,
            'group_ids' => [ 1, 6, 9 ],
            'tags' => [ 'hey', 'hi', 'hello' ],
            'significant_dates' => [ '2012-01-01', '2012-01-02' ],
            'answers_path' => [ true, false, true ],
            'extended' => {
              'id' => 44,
              'whoami' => '...'
            }
          }
        ]
      }
      model = ObjExtTypedModel.from_raw(data['data'].first, @cache)
      result = @repo.insert(model)
      expect(result).to be_an_instance_of(TSheets::Result)
    end

  end
end

