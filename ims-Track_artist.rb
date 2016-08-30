class Track_artist
  def initialize(track,artist,played=0,data)
    @t=String track
    @a=artist
    @p=played
    @data=data
  end
  def display_t
    puts "Track:#{@t}"
    puts "Artist:#{@a}"
    puts "It has been played:#{@p} times"
  end
  def save_toStore
    data0=JSON.parse(@data)
    data0[@t]=[@a,@p]
    store = YAML::Store.new('track_data.yml')
    store.transaction{
      store[:data] = JSON data0
      store.commit
    }
  end
end
