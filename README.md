# TSheets API - Ruby client library

This is the Ruby library for connecting with tsheets.com API

# Usage

Below examples assume that you properly added the tsheets gem into your Gemfile or have loaded the library in any other way.

## Authentication

TSheets platform uses OAuth2 for authentication. Because of the character of the library, it doesn't deal with the process of obtaining the authentication token needed for the OAuth2 protocol. You can find information about obtaining the token statically via the application's interface here: [https://developers.tsheets.com/docs/api/authentication]()

Once the auth token is obtained, a user has to create the 'api' instance object e.g:

```ruby
api = TSheets::API.new do |config| 
  config.access_token = 'someauthtoken'
end
```

## Basics

The 'api' instance gives access to different resource end points e. g:

```ruby
api.timesheets.where(start_date: some_start, end_date: some_end)
```

The 'timesheets' method returns an instance of the timesheets end point repository. Repositories are means of communication with the TSheets API. They provide ways of fetching data as well as updating, inserting or deleting.

### Fetching data

The above example returns a "lazy query" - it doesn't connect with the TSheets API unless you need to get the resulting items out if it. Because such queries are enumerables - one can use any method defined in the standard Ruby's Enumerable module (like take, map, find or reduce). To get all the items at once:

```ruby
api.timesheets.where(start_date: some_start, end_date: some_end).all
```

One could also fetch only the first 10 with:

```ruby
api.timesheets.where(start_date: some_start, end_date: some_end).take(10)
```

Some of the end points will always yield at most one result. In such case it's handy to just use:

```ruby
# The current_user end point returns a User
api.current_user.first
```

### Inserting new data

Some end points permit insertion of new data. This is accomplished with e. g:

```ruby
timesheet = TSheets::Models::Timesheet.new(user_id: 1, type: 'manual', date: '2015-01-01', duration: 60*60)
result = api.timesheets.insert(timesheet)
```


The 'result' variable there contains the context info about the operation. You can check if it went well with:

```ruby
if result.success?
  # some logic here
end
```

In case it didn't went well, you can obtain the useful explanation with:

```ruby
if !result.success?
  puts result.message
end
```

At any point you can grab the resulting JSON with:

```ruby
result.body
```

### Updating data

Updates are being done in the same way as inserts. You just need to use the **update** method instead:

```ruby
result = api.someendpoint.update(some_object)
if result.success?
  puts 'Yay!'
else
  puts "Error: #{result.message}"
end
```

### Deletes

Deletes follow the same pattern as inserts and updates:

```ruby
result = api.someendpoint.delete(some_object)
if result.success?
  puts 'Gone for good!'
else
  puts "Error: #{result.message}"
end
```

### Specifics

All information about possible filters one can pass to **where**, or required when inserting or updating are available e. g: [https://developers.tsheets.com/docs/api/]()

## Reports

There are three report types one can ask the API for. Fetching them follows the same pattern as normal fetches with **where**, only difference being the **report** method that's being in use e. g:

```ruby
api.payroll.report(start_date: Date.parse('2015-01-01'), end_date: Date.parse('2015-05-01')).first
# <TSheets::Models::Payroll :user_id=>1, :client_id=>1, :start_date=>#<Date: 2015-01-01 ((2457024j,0s,0n),+0s,2299161j)>, :end_date=>#<Date: 2015-05-01 ((2457144j,0s,0n),+0s,2299161j)>, :total_re_seconds=>7200, :total_ot_seconds=>0, :total_dt_seconds=>0, :total_pto_seconds=>0, :total_work_seconds=>7200, :pto_seconds=>>
```
