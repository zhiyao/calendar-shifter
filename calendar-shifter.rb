#icalendar tool to shift ics calendar
#to use ruby calendar-reader.rb generate --input input.ics --start_date 2017/01/01 --start_time 7 --output cal.ics --timezone Asia/Singapore

require 'icalendar'
require 'icalendar/tzinfo'
require 'tzinfo'
require 'time'
require 'date'
require 'thor'

class DateShifter < Thor
  option :input
  option :start_date
  option :start_time
  option :output
  option :timezone
  desc "generate", "generating calendar based on the input calendar"
  def generate
    input = options[:input] || 'insanity.ics'
    start_date = Time.parse(options[:start_date]) || DateTime.now
    start_time = options[:start_time].to_i || 8
    output = options[:output] || 'output.ics'
    timezone = options[:timezone] || 'Asia/Singapore'
    main(input, start_date, start_time, timezone, output)
  end

  private

  def main(input, start_date, start_time, timezone, output)
    cal_file = File.open(input)
    output_cal = Icalendar::Calendar.new
    cal = parse_calendar_file(cal_file)

    first_date = get_reference_first_day(cal)
    shift = days_apart(first_date, start_date)
    shift_time = time_apart(first_date, start_time)

    output_cal.add_timezone time_zone(timezone, start_date)

    cal.events.each do |event|
      start_time = shift_event_time(shift_time, shift, event.dtstart)
      end_time = shift_event_time(shift_time, shift, event.dtend)
      event.dtstart = Icalendar::Values::DateTime.new start_time, tzid: timezone
      event.dtend = Icalendar::Values::DateTime.new end_time, tzid: timezone
      puts "output starttime #{event.dtstart}"
      puts "output endtime #{event.dtend}"
      puts "event: #{event.summary}"
      puts "***"
      output_cal.events.push(event)
    end
  end

  def write_to_file(output, output_cal)
    File.open(output, 'w') do |file|
      file.write(output_cal.to_ical)
    end
  end

  def days_apart(reference_date, desired_date)
    -(reference_date - desired_date).to_i / 1.day
  end

  def time_apart(reference_time, desired_time)
    (reference_time.hour - desired_time)
  end

  def get_reference_first_day(cal)
    Time.parse("#{cal.events.first.dtstart}")
  end

  def parse_calendar_file(cal_file)
    strict_parser = Icalendar::Parser.new(cal_file, true)
    strict_parser.parse.first
  end

  def time_zone(tzid, start_date)
    tz = TZInfo::Timezone.get tzid
    tz.ical_timezone start_date
  end

  def shift_event_time(shift_time, shift, event_dt)
    Time.parse("#{event_dt}") + (-shift_time.hours) + (shift.days)
  end
end

DateShifter.start(ARGV)

