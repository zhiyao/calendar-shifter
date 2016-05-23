# Introduction

Ruby tool to shift calendar dates and time given in ics file.

Wanting to keep fit, I got an insanity calendar file off the internet, everything was right except for the dates and time. Wanted a way to shift the dates and time without doing it manually on google calendar.

# Installation

Make sure you have ruby installed in your computer

    gem install bundler
    bundle install

# Usage

    ruby calendar-shifter.rb generate --input insanity.ics --start_date 2017/01/01 --start_time 7 --output cal.ics --timezone Asia/Singapore

[Check the Time Zone in the tz column](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones)
