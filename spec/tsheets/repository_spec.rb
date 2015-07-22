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
        expect(TSheets::TestAdapter).to receive(:get).with(anything(), hash_including(params), anything()).and_return(OpenStruct.new({ code: 200, to_str: { results: { obj_typed_models: {} }, more: false }.to_json }))
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

    it 'properly parses singleton responses' do
      response_json = <<-EOF
{
 "results": {
  "obj_effective_settings": {
   "general": {
    "last_modified": "2013-06-20T19:16:12+00:00",
    "settings": {
     "tz": "tsMT",
     "week_start": "6",
     "clockout_override_hours": "8",
     "payroll_end_date": "2013-05-24",
     "payroll_timezone": "-7",
     "employee_pto_entry": "0",
     "payroll_type": "biweekly",
     "emp_panel_email": "0",
     "calculate_overtime": "1",
     "daily_overtime": "1",
     "daily_doubletime": "1",
     "daily_doubletime_hours": "12",
     "seventh_consecutive_dt": "1"
    }
   },
   "time_entry": {
    "settings": {
     "installed": 1,
     "time_entry_method": "timecard",
     "time_entry": 0,
     "timecard": 1,
     "weekly_timecard": 1,
     "timecard_daily": 0,
     "timesheet_edit": 0,
     "timesheet_map": 0,
     "pto_entry": 1
    }
   },
   "invoicing": {
    "settings": {
     "installed": 1
    }
   },
   "alerts": {
    "settings": {
     "installed": "1",
     "day_hours": "0",
     "day_hours__notify_employee": "email",
     "week_hours": "0"
    },
    "last_modified": "2013-05-31T21:58:23+00:00"
   },
   "dialin": {
    "settings": {
     "installed": "1",
     "transcribe_notes": "1"
    },
    "last_modified": "2013-05-29T16:09:54+00:00"
   },
   "not_in_spec": {
    "settings": {
     "installed": "1",
     "transcribe_notes": "1"
    },
    "last_modified": "2013-05-29T16:09:54+00:00"
   },
   "sounds": {
    "settings": {
     "clock_in_sound": "http:\/\/cdn.tsheets.com\/sounds\/global\/karate_1.mp3",
     "clock_out_sound": "http:\/\/cdn.tsheets.com\/sounds\/global\/hallelujah.mp3",
     "installed": "1",
     "sounds_on": "1",
     "switch_sound": "http:\/\/cdn.tsheets.com\/sounds\/global\/drip.mp3",
     "ts_save_sound": "http:\/\/cdn.tsheets.com\/sounds\/global\/drums_3.mp3",
     "sounds_notify": "1"
    },
    "last_modified": "2013-05-31T18:19:56+00:00"
   }
  }
 }
}
      EOF
      repo = ObjEffectiveSettingsRepo.new(fake_bridge, fake_cache)
      expect(TSheets::TestAdapter).to receive(:get).and_return(OpenStruct.new({code: 200, to_str: response_json}))
      results = repo.where({}).all
      expect(results.count).to eq(1)
      settings = results.first
      expect(settings.general).to be_an_instance_of(Hash)
      expect(settings.time_entry).to be_an_instance_of(Hash)
      expect(settings.invoicing).to be_an_instance_of(Hash)
      expect(settings.alerts).to be_an_instance_of(Hash)
      expect(settings.dialin).to be_an_instance_of(Hash)
      expect(settings.sounds).to be_an_instance_of(Hash)
      expect(settings.not_in_spec).to be_an_instance_of(Hash)
    end
  end

  describe 'first() method' do
    before(:each) do
      @repo = ObjRepo.new(fake_bridge, fake_cache)
    end
    it 'exists' do
      expect(@repo).to respond_to(:first)
    end
    it 'is a shortcut for all.first' do
      expect_any_instance_of(TSheets::Results).to receive(:all).exactly(1).and_return([1,2,3])
      expect(@repo.first).to eq(1)
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

    it 'only sends the fields that have not been excluded' do
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
      truncated_data = {
        'data' => [
          {
            'name' => "Name1",
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
      expect(TSheets::TestAdapter).to receive(:post).with(anything, truncated_data, anything).and_call_original
      @repo.insert(model)
    end

  end

  describe 'delete() method' do
    before(:each) do
      @cache = fake_cache
      @repo = ObjExtTypedRepo.new(fake_bridge, @cache)
    end

    it 'is only available for repos with :delete in methods' do
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
      expect(TSheets::TestAdapter).not_to receive(:delete).with('https://rest.tsheets.com/api/v1/ext_typed_objects', data, anything())
      model = ObjExtTypedModel.from_raw(data['data'].first, @cache)
      expect { @repo.delete(model) }.to raise_exception(TSheets::MethodNotAvailableError)
    end

    it 'calls the service with the id of the entity stored in the ids array in params' do
      @repo = ObjExtTypedRepoDeleteOnly.new(fake_bridge, @cache)
      data = {
        'data' => [
          {
            'id' => 34,
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
      expect(TSheets::TestAdapter).to receive(:delete).with('https://rest.tsheets.com/api/v1/ext_typed_objects', { ids: [ 34 ] }, anything()).and_call_original
      model = ObjExtTypedModel.from_raw(data['data'].first, @cache)
      @repo.delete(model)
    end
  end

  describe '#report method' do
    before(:each) do
      @cache = fake_cache
      @repo = ObjReportRepo.new(fake_bridge, @cache)
    end

    it 'is only available for repos with :report in methods' do
      repo2 = ObjExtTypedRepo2.new(fake_bridge, @cache)
      expect { repo2.report({}) }.to raise_exception(TSheets::MethodNotAvailableError)
      expect { @repo.report({}) }.not_to raise_exception(TSheets::MethodNotAvailableError)
    end

    it 'sends a POST request to the web service' do
      expect(TSheets::TestAdapter).to receive(:post).and_return OpenStruct.new({
        code: 200,
        to_str: {
          "results": {
            "obj_report": {
              "191544": {
                "user_id": 191544,
                "ratio": 183.56
              }
            }
          }
        }.to_json
      })
      @repo.report({}).first
    end

    it 'properly returns instances of reports' do
      expect(TSheets::TestAdapter).to receive(:post).and_return OpenStruct.new({
        code: 200,
        to_str: {
          "results": {
            "obj_report": {
              "191544": {
                "user_id": 191544,
                "ratio": 183.56
              },
              "191545": {
                "user_id": 191545,
                "ratio": 183.56
              },
              "191546": {
                "user_id": 191546,
                "ratio": 183.56
              }
            }
          }
        }.to_json
      })
      reports = @repo.report({}).all
      expect(reports.count).to eq(3)
      expect(reports.map(&:user_id)).to eq([191544, 191545, 191546])
    end

  end
end

