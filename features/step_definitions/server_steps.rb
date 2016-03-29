Given(/^I have an NTP service that is running on localhost$/) do
  # this is started in hooks
end

When(/^I request the time from it$/) do
  Net::NTP.get('localhost', SERVER_PORT)
  @time = Net::NTP.get.time.to_f
  # This is just to test the cuke scenario
  # @time = @server.get_time.to_f
end

Then(/^the time is near to now$/) do
  expect(time_diff(@time, Time.now)).to be < 1
end

When(/^I change the time to '(\d+)\/(\d+)\/(\d+)T(\d+):(\d+):(\d+)'$/) do |year, month, day, hour, minute, second|
  @new_time = Time.new(year.to_i, month.to_i, day.to_i, hour.to_i, minute.to_i, second.to_i)
  @server.change_time(@new_time)
end

Then(/^the time is near to '(\d+)\/(\d+)\/(\d+)T(\d+):(\d+):(\d+)'$/) do |_year, _month, _day, _hour, _minute, _second|
  expect(time_diff(@time, @new_time)).to be < 1
end

When(/^I reset it$/) do
  @server.reset
end

def time_diff(time_a, time_b)
  time_a.to_f - time_b.to_f
end
