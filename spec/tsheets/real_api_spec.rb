require 'spec_helper'

# For the sake of testing real world data and ensuring the library
# parses it correctly
describe 'Real TSheets API' do
  it 'fetches timesheets properly' do
    data = {"results"=>{"timesheets"=>{"208496189"=>{"id"=>208496189, "user_id"=>2052270, "jobcode_id"=>0, "start"=>"2015-07-06T06:34:36-04:00", "end"=>"2015-07-06T06:34:52-04:00", "duration"=>16, "date"=>"2015-07-06", "tz"=>-4, "tz_str"=>"America/New_York", "type"=>"regular", "location"=>"(Wilczyce, Dolnoslaskie, PL?)", "on_the_clock"=>false, "locked"=>0, "notes"=>"Yyyyyy", "last_modified"=>"2015-07-06T10:34:52+00:00", "customfields"=>""}}}, "more"=>false, "supplemental_data"=>{"users"=>{"2052270"=>{"id"=>2052270, "first_name"=>"Kamil", "last_name"=>"", "group_id"=>0, "active"=>true, "employee_number"=>0, "salaried"=>false, "exempt"=>false, "username"=>"user@company.com", "email"=>"user@company.com", "payroll_id"=>"", "hire_date"=>"0000-00-00", "term_date"=>"0000-00-00", "last_modified"=>"2015-05-18T15:55:05+00:00", "last_active"=>"2015-07-06T10:34:52+00:00", "created"=>"2015-05-18T15:55:05+00:00", "client_url"=>"endpoint", "mobile_number"=>"", "approved_to"=>"", "submitted_to"=>"", "manager_of_group_ids"=>[], "require_password_change"=>false, "permissions"=>{"admin"=>true, "mobile"=>false, "status_box"=>false, "reports"=>false, "manage_timesheets"=>false, "manage_authorization"=>false, "manage_users"=>false, "manage_my_timesheets"=>false, "manage_jobcodes"=>false, "approve_timesheets"=>false}}}}}
    repo = TSheets::Repos::Timesheets.new(fake_bridge, fake_cache)
    expect(TSheets::TestAdapter).to receive(:get).and_return(OpenStruct.new({
      code: 200,
      to_str: JSON.dump(data)
    }))
    expect { repo.where(start_date: DateTime.parse("2012-01-01"), end_date: DateTime.now).all }.not_to raise_exception
  end
end
