require 'yaml/store'
require 'rubygems'
require 'json'
require 'minitest/autorun'
load 'ims-IMS_Loop.rb'
load 'ims-Command.rb'
load 'ims-Track_artist.rb'


describe "command:help" do
  it "print several lines of instruction" do
    Command.respond('help',4)
  end
end


describe "command:info Jay" do
  it "display the Jay's tracks or the infomation of track Jay" do
    Command.respond('info Jay',8)
  end
end

describe "command:info song2" do
  it "display the song2's tracks or the infomation of track song2" do
    Command.respond('info song2',9)
  end
end

describe "command:add song99 by Yan" do
  it "add the track song99 and its' artist_name Yan" do
    Command.respond('add song99 by Yan',17)
  end
end

describe "command:delete song99" do
  it "delete the track song99 and its' artist_name Yan" do
    Command.respond('delete song99',20)
  end
end

describe "command:info" do
  it "display all the data" do
    Command.respond('info',4)
  end
end
