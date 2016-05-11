Given(/^I have an NTP service that is running on localhost$/) do
  # this is started in hooks
end

Then(/^the requested time is near to now$/) do
  wait_for{ get_time }.to be_within(1).of(Time.new)
end

When(/^I change the time to '(\d+)\/(\d+)\/(\d+)T(\d+):(\d+):(\d+)'$/) do |year, month, day, hour, minute, second|
  @new_time = Time.new(year.to_i, month.to_i, day.to_i, hour.to_i, minute.to_i, second.to_i)
  @server.time(@new_time)
end

Then(/^the requested time is near to '(\d+)\/(\d+)\/(\d+)T(\d+):(\d+):(\d+)'$/) do |year, month, day, hour, minute, second|
  @new_time = Time.new(year.to_i, month.to_i, day.to_i, hour.to_i, minute.to_i, second.to_i)
  wait_for{ get_time }.to be_within(1).of(@new_time)
end

When(/^I reset it$/) do
  @server.reset
end

