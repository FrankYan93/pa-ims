def help
  puts "'Help' : display a simple help screen"
  puts "'Exit' : save state and exit"
  puts "'Info' : display a high level summary of the state"
  puts "'Info ' + track_name or artist_name to see detail"
  puts "'Add ' + track_name by(you must use ' by ' to seperate) artist_name(if not given,it would be default) to add new track to an artist"
  puts "'Play ' + track_name to play the track(record + 1)"
  puts "'Count tracks ' + a certain name of artist : Display how many tracks are known by a certain artist"
  puts "'List tracks ' + a certain name of artist : Display the tracks played by a certain artist"
  puts "'Delete' + a certain name of track to delete the track"
  puts "'Update ' + track_name by(you must use ' by ' to seperate) artist_name to update the data"
end
def info(data0,usr_command,command_len,data)
  flag=false
  data0.each{|x,y|
    if x.to_s==usr_command[(5...command_len)]
      trackInfo=Track_artist.new(x,y[0],y[1],data)
      trackInfo.display_t
      flag=true
    end
    if y[0].to_s==usr_command[(5...command_len)]
      trackInfo=Track_artist.new(x,y[0],y[1],data)
      trackInfo.display_t
      flag=true
    end
  }
  puts "Data not found!"unless flag
end
def add(data0,usr_command,command_len,data)
  flag =false
    flag=usr_command[(4...command_len)].include?" by "
    ar="default"
    if flag
      label=usr_command.rindex(" by ")-1
      tr=usr_command[(4..label)]
      ar=usr_command[(label+5...command_len)] if command_len>(label+5)
    else
      tr=usr_command[(4...command_len)]
    end

    if !(data0.has_key?(tr))
      trackInfo=Track_artist.new(tr,ar,0,data)
      trackInfo.display_t
      trackInfo.save_toStore
      return false
    else
      puts "This track already exist!"
      return true
    end
end
def play(data0,usr_command,command_len)
  data0.each{|x,y|
    if x==usr_command[(5...command_len)]
      y[1]+=1;
    end
  }
  return data0
end
def delete(data0,usr_command,command_len)
  flag=false
  data0.each{|x,_y|
    if x==usr_command[(7...command_len)]
      data0.delete(x)
      flag=true
    end
  }
  puts "Track not found" unless flag
  return data0
end
def count(data0,usr_command,command_len,complex_command)
  if complex_command[1]!="tracks"
    puts "You typed a command that is not very precise,but it does not matter since we only care about the third word!"
  end
  total=0
  flag=true
  if complex_command[2]!=nil
    label=usr_command.rindex(complex_command[2])
  else
    puts "not a good command"
    flag= false
  end
  if flag
      data0.each{|_x,y|
        if y[0]==usr_command[(label...command_len)]
          total+=1
        end
      }
  end
  if total==0
    puts "Artist not found!"
  else
    puts total
  end
end
def update(data0,usr_command,command_len,data)
  ar="default"
  s=" by "
  if usr_command.include?" by "
    label=usr_command.rindex(s)
    tr=usr_command[(7...label)]
    ar=usr_command[((label+4)...command_len)] if command_len>(label+4)
  else
    tr=usr_command[(7...command_len)]
  end

  if data[tr]!=nil
    data0[tr][0]=ar
  else
    puts "Track not found"
  end
  return data0
end
def list(data0,usr_command,command_len,complex_command)
  if complex_command[1]!="tracks"
      puts "You typed a command that is not very precise,but it does not matter since we only care about the third word!"
    end
    flag=false
    if complex_command[2]==nil
      puts "Command error:you must type the artist_name begin at the third word"
    else
      label=usr_command.rindex(complex_command[2])
      data0.each{|x,y|
        if y[0]==usr_command[(label...command_len)]
          puts x
          flag=true
        end
      }
      puts "Artist not found" unless flag
    end
  end
class Command
  def self.respond(usr_command,command_len)
    store = YAML::Store.new('track_data.yml')
    data = store.transaction { store[:data] }
    data ||= {}
    data0=JSON.parse(data)
    bigFlag=true
    case usr_command
    when "Help","help" then
      help
    when "Info","info" then
      puts data
    else
      complex_command=usr_command.split(' ')
      if complex_command.length>1
        complex_command[0].capitalize! unless complex_command[0].capitalize==nil
        case complex_command[0]
        when "Info"
          info(data0,usr_command,command_len,data)
        when "Add"
          bigFlag=add(data0,usr_command,command_len,data)
        when "Play"
          data0=play(data0,usr_command,command_len)
        when "Delete"
          data0=delete(data0,usr_command,command_len)
        when "Count"
          count(data0,usr_command,command_len,complex_command)
        when "Update"
          update(data0,usr_command,command_len,data)
        when "List"
          list(data0,usr_command,command_len,complex_command)
        else
          puts "Error:command not found!"
        end
      else
        puts "Error:command not found!"
      end
    end
    if bigFlag
      data=JSON data0
      store.transaction{
        store[:data] = data
        store.commit
      }
    end
    print ">"
  end
end
