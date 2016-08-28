# IMS
I've tried PStore and YAML:Store.
PStore is quick but not readable while YAML:Store is readable but not so quick.

my date structure{
  key:tracks => value:an array includes artist and played times,
  ...
}

my solution: 
  use "case" to switch from different commands, 
  identify " by " to seperate track and artist, 
  use a class Track_artist to add new tracks and display, 
  command "Help" to see all commands.
