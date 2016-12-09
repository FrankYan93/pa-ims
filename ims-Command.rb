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

def info(data0, usr_command, command_len, data)
    flag = false
    data0.each do |x, y|
        if x.to_s == usr_command[(5...command_len)]
            trackInfo = Track_artist.new(x, y[0], y[1], data)
            trackInfo.display_t
            flag = true
        end
        next unless y[0].to_s == usr_command[(5...command_len)]
        trackInfo = Track_artist.new(x, y[0], y[1], data)
        trackInfo.display_t
        flag = true
    end
    puts 'Data not found!' unless flag
end

def add(data0, usr_command, command_len, data)
    flag = usr_command[(4...command_len)].include?' by '
    ar = 'default'
    if flag
        label = usr_command.rindex(' by ') - 1
        tr = usr_command[(4..label)]
        ar = usr_command[(label + 5...command_len)] if command_len > (label + 5)
    else
        tr = usr_command[(4...command_len)]
    end

    if !data0.key?(tr)
        trackInfo = Track_artist.new(tr, ar, 0, data)
        trackInfo.display_t
        trackInfo.save_toStore
        return false
    else
        puts 'This track already exist!'
        return true
    end
end

def play(data0, usr_command, command_len)
    data0.each do |x, y|
        y[1] += 1 if x == usr_command[(5...command_len)]
    end
    data0
end

def delete(data0, usr_command, command_len)
    flag = false
    data0.each do |x, _y|
        if x == usr_command[(7...command_len)]
            data0.delete(x)
            flag = true
        end
    end
    puts 'Track not found' unless flag
    data0
end

def count(data0, usr_command, command_len, complex_command)
    if complex_command[1] != 'tracks'
        puts 'You typed a command that is not very precise,but it does not matter since we only care about the third word!'
    end
    total = 0
    flag = true
    if !complex_command[2].nil?
        label = usr_command.rindex(complex_command[2])
    else
        puts 'not a good command'
        flag = false
    end
    if flag
        data0.each do |_x, y|
            total += 1 if y[0] == usr_command[(label...command_len)]
        end
    end
    if total == 0
        puts 'Artist not found!'
    else
        puts total
    end
end

def update(data0, usr_command, command_len, data)
    ar = 'default'
    s = ' by '
    if usr_command.include?' by '
        label = usr_command.rindex(s)
        tr = usr_command[(7...label)]
        ar = usr_command[((label + 4)...command_len)] if command_len > (label + 4)
    else
        tr = usr_command[(7...command_len)]
    end

    if !data[tr].nil?
        data0[tr][0] = ar
    else
        puts 'Track not found'
    end
    data0
end

def list(data0, usr_command, command_len, complex_command)
    if complex_command[1] != 'tracks'
        puts 'You typed a command that is not very precise,but it does not matter since we only care about the third word!'
    end
    flag = false
    if complex_command[2].nil?
        puts 'Command error:you must type the artist_name begin at the third word'
    else
        label = usr_command.rindex(complex_command[2])
        data0.each do |x, y|
            if y[0] == usr_command[(label...command_len)]
                puts x
                flag = true
            end
        end
        puts 'Artist not found' unless flag
    end
end
class Command
    def self.respond(usr_command, command_len)
        bigFlag = true
        store = YAML::Store.new('track_data.yml')
        data0 = JSON.parse(store.transaction { store[:data] } || {}.to_json)
        case usr_command
        when 'Help', 'help' then help
        when 'Info', 'info' then data0.each { |key, value| print "\nTrack name:#{key}\nArtist:#{value[0]}\nPlay time:#{value[1]}\n" }
        else
            complex_command = usr_command.split(' ')
            if complex_command.length > 1
                complex_command[0].capitalize! unless complex_command[0].capitalize.nil?
                case complex_command[0]
                when 'Info' then info(data0, usr_command, command_len, data)
                when 'Add' then bigFlag = add(data0, usr_command, command_len, data)
                when 'Play' then data0 = play(data0, usr_command, command_len)
                when 'Delete' then data0 = delete(data0, usr_command, command_len)
                when 'Count' then count(data0, usr_command, command_len, complex_command)
                when 'Update' then update(data0, usr_command, command_len, data)
                when 'List' then list(data0, usr_command, command_len, complex_command)
                else  puts 'Error:command not found!'
                end
            else  puts 'Error:command not found!'
            end
        end
        data = data0.to_json
        store.transaction { store[:data] = data; store.commit } if bigFlag
    end
end
