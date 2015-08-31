require 'date'
require 'tsheets'
require 'tsheets/models'
require 'colorize'

namespace :test do
  task :quick do

    token = ENV['token']
    verbose = ENV['mode'] == 'verbose'

    if token.nil?
      puts "You need to specify the access token to connect to a real TSheets service".red
      puts "> rake test:quick token=Iamatoken".red
      next
    end

    if verbose
      puts "Running in the verbose mode".green
      Typhoeus::Config.verbose = true
    end

    api = TSheets::API.new do |config|
      config.access_token = token
    end

    # who am i?
    current_user = api.current_user.first
    user_id = current_user.id

    puts "Successfully connected to TSheets. Grabbed the current user's id = #{user_id}".green

    # get a list of job codes
    my_jobcode = nil
    jobcodes = api.jobcodes.where(type: 'regular', active: true)
    jobcodes.each do |jobcode|
      if jobcode.name == 'Ancient Artifacts Inc.'
        my_jobcode = jobcode;
      end
    end
    if my_jobcode.nil?
      puts "No jobcode named 'Ancient Artifacts Inc.' found. Make sure you have that created for your account for this test to continue".red
      next
    end
    puts " - Selecting Jobcode '#{my_jobcode.name}'"

    # check to see if I am already on the clock
    timesheet = nil
    timesheets = api.timesheets.where(modified_since: DateTime.parse('2015-08-01'), on_the_clock: true, user_ids: [current_user.id])
    if timesheets.all.length > 0
      puts ' - Already clocked-in'
      timesheet = timesheets.first
    else
      puts ' - Not clocked-in'
    end

    # Toggle clock-in or clock-out
    if timesheet == nil
      puts ' - Clocking in'

      # create a new timesheet
      timesheet = TSheets::Models::Timesheet.new
      timesheet.type = 'regular'
      timesheet.start = DateTime.now
      timesheet.end = nil
      timesheet.user_id = user_id
      timesheet.jobcode_id = my_jobcode.id
      result = api.timesheets.insert(timesheet)
      puts result.message.red unless result.success?
    else
      puts ' - Clocking out'

      # edit existing timesheet
      timesheet.end = DateTime.now
      result = api.timesheets.update(timesheet)
      puts result.message.red unless result.success?
    end

    puts 'done'.green
  end
end
