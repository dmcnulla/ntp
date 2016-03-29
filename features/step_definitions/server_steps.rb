Given(/^I have an NTP service that is running on localhost$/) do
  # this is started in hooks
end

When(/^I request the time from it$/) do
  Net::NTP.get('localhost', SERVER_PORT)
  @time = Net::NTP.get.time
end

Then(/^the time is near to now$/) do
  expect(@time).to eq(Time.now)
end

When(/^I change the time to '(\d+)\/(\d+)\/(\d+)T(\d+):(\d+):(\d+)'$/) do |year, month, day, hour, minute, second|
  @new_time = Time.new(year.to_i, month.to_i, day.to_i, hour.to_i, minute.to_i, second.to_i)
end

Then(/^the time is near to '(\d+)\/(\d+)\/(\d+)T(\d+):(\d+):(\d+)'$/) do |year, month, day, hour, minute, second|
  expect(@time).to eq(@new_time)
end
