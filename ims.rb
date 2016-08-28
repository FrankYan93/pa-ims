require 'yaml/store'
store = YAML::Store.new('track_data.yml')
$data = store.transaction { store[:data] }

if $data==nil
  $data = {}
end

class Track_artist
  def initialize(track,artist,played=0)
    @t=track
    @a=artist
    @p=played
  end
  def display_t
    puts "Track:#{@t}"
    puts "Artist:#{@a}"
    puts "It has been played:#{@p} times"
  end
  def save_toStore
    $data[@t.to_sym]=[@a,@p]
  end
end

puts "Tell me your command('Help' for cheking all commands):"
print ">"
usr_command=gets.chomp
command_len=usr_command.length

while usr_command!="Exit"
case usr_command
when "Help"
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
when "Info"
  puts $data
else
  complex_command=usr_command.split(' ')
  if complex_command.length>1
    case complex_command[0]
    when "Info"
      flag=false
      $data.each{|x,y|
        if x.to_s==usr_command[(5...command_len)]
          trackInfo=Track_artist.new(x,y[0],y[1])
          trackInfo.display_t
          flag=true
        end
        if y[0].to_s==usr_command[(5...command_len)]
          trackInfo=Track_artist.new(x,y[0],y[1])
          trackInfo.display_t
          flag=true
        end
      }
      puts "Data not found!"unless flag
    when "Add"
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

      if $data[tr.to_sym]==nil
        trackInfo=Track_artist.new(tr,ar)
        trackInfo.display_t
        trackInfo.save_toStore
      else
        puts "This track already exist!"
      end

    when "Play"
      $data.each{|x,y|
        if x.to_s==usr_command[(5...command_len)]
          y[1]+=1;
        end
      }
    when "Delete"
      flag=false
      $data.each{|x,_y|
        if x.to_s==usr_command[(7...command_len)]
          $data.delete(x)
          flag=true
        end
      }
      puts "Track not found" unless flag
    when "Count"
      if complex_command[1]!="tracks"
        puts "You typed a command that is not very precise,but it does not matter since we only care about the third word!"
      end
      total=0
      label=usr_command.rindex(complex_command[2])
      $data.each{|_x,y|
        if y[0]==usr_command[(label...command_len)]
          total+=1
        end
      }
      if total==0
        puts "Artist not found!"
      else
        puts total
      end
    when "List"
      if complex_command[1]!="tracks"
        puts "You typed a command that is not very precise,but it does not matter since we only care about the third word!"
      end
      flag=false
      if complex_command[2]==nil
        puts "Command error:you must type the artist_name begin at the third word"
      else
        label=usr_command.rindex(complex_command[2])
        $data.each{|x,y|
          if y[0]==usr_command[(label...command_len)]
            puts x.to_s
            flag=true
          end
        }
          puts "Artist not found" unless flag
      end
    when "Update"
      ar="default"
      s=" by "
      if usr_command.include?" by "
        label=usr_command.rindex(s)
        tr=usr_command[(7...label)]
        ar=usr_command[((label+4)...command_len)] if command_len>(label+4)
      else
        tr=usr_command[(7...command_len)]
      end

      if $data[tr.to_sym]!=nil
        $data[tr.to_sym][0]=ar
      else
        puts "Track not found"
      end
    else
      puts "Error:command not found!"
    end
  else
    puts "Error:command not found!"
  end

end
store.transaction{
  store[:data] = $data
  store.commit
}
print ">"
usr_command=gets.chomp
command_len=usr_command.length
end

puts "Bye!"
