# MusicBlender
[![Code Climate](https://codeclimate.com/github/jsgarvin/music_blender.png)](https://codeclimate.com/github/jsgarvin/music_blender)

A ruby wrapper around [mpg123](http://www.mpg123.de/ "mpg123") providing some additional features.

## Motivation

I was unsatisfied with how every other mp3 player I'd tried randomized music. So, I wrote my own to satisfy my desires.  Maybe it will satisy yours, too.

MusicBlender...

1. allows you to rate songs on any scale you choose (but I recommend using 1-11). 
2. writes ratings to custom field in ID3 tags, for persistance across devices.
3. plays those with a higher rating more frequently.
4. is more likely to play a song that it hasn't played in a while than another of equal rating that it's played more recently.
5. will not play songs by the same artist too close to each other.
6. supports relative volume adjustments embeded in ID3 tags with mpg123's --rva-mix flag.
7. currently is operated from it's own command shell.  Maybe someday I'll create a GUI.  Maybe I won't.

## Dependencies

You must have [mpg123](http://www.mpg123.de/ "mpg123") installed and in your path. MusicBlender does *not* play well with mpg321.

Obviously, you will also need [ruby](https://www.ruby-lang.org) installed and, for easy installation, [ruby-gems](https://rubygems.org/pages/download).

## Installation

1. install [mpg123](http://www.mpg123.de/ "mpg123")
2. `gem install music_blender`

## Quick Start

1. From the console, run `blender /path/to/music/folder`
2. From MusicBlender's command prompt, enter `play`

## Additional Commands

1. `pause` - pause and restart playback.
2. `play` - play a new song (aborts current song if already playing).
3. `stop` - stop playback.
4. `exit` - stop playback and exit.
5. `info` - print out info about currently play song.
6. `rate` # - set current songs rating to #.

