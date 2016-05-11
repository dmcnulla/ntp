When(/^I check the "([^"]*)"$/) do |path|
  get(path)
  expect(last_response).to be_ok
end

Then(/^I receive "([^"]*)"$/) do |expected_body|
  check_body(expected_body)
end

When(/^I request the status from the rest server$/) do
  get('/status')
  expect(last_response).to be_ok
end

Then(/^the status is "([^"]*)"$/) do |expected_body|
  check_body(expected_body)
end

def check_body(expected_body)
  expect(last_response.body).to eq(expected_body)
end

When(/^I request to set the date to "([^"]*)" and time to "([^"]*)" in the rest server$/) do |date, time|
  put("/date/#{date}/time/#{time}")
  expect(last_response).to be_ok
end

def verify_code
  expect(last_response).to be_ok
end

When(/^I request to reset the time in the rest server$/) do
  post('/time/reset')
  expect(last_response).to be_ok
end

When(/^I request the time from it$/) do
  get('/time')
  expect(last_response).to be_ok
end

Then(/^the time is near to "([^"]*)"$/) do |expected_time|
  puts last_response.body
  expect(Time.new(last_response.body.to_i) - expected_time.to_i).to be < 1
end

Then(/^the time is near to now$/) do
  expected_time = Time.new
  puts last_response.body
  expect(Time.new(last_response.body.to_i) - expected_time.to_i).to be < 1
end
