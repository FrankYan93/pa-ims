# IMS [![Code Climate](https://codeclimate.com/github/FrankYan93/pa-ims/badges/gpa.svg)](https://codeclimate.com/github/FrankYan93/pa-ims)
I've tried PStore and YAML:Store.
PStore is quick but not readable while YAML:Store is readable but not so quick.

my date structure{
  key:tracks => value:an array includes artist and played times,
  ...
}

my solution:
  class IMS_Loop :do the loop job------
  class Commmand :respond to user's commands------
  class Track_artist :display and add track,artist pair to YAML:Store------
  JSON data :store the data to and from YAML:Store------
  Hash data0 :transform data in order to use "each" fuction,then restore to data------

  use "case" to switch from different commands,
  identify " by " to seperate track and artist,
  use a class Track_artist to add new tracks and display,
  command "Help" to see all commands.


Thank you for reading.
Version 8/29/2016
