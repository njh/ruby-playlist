# Module to parse and generate M3U playlists
module Playlist::Format::M3U
  class << self
    # Parse a M3U file into a [Playlist]
    # @param input any object that responds to #each_line
    #        (either a String or a IO object)
    # @return [Playlist] a new Playlist object
    def parse(input)
      Playlist.new do |playlist|
        track = Playlist::Track.new
        input.each_line do |line|
          if line =~ /^#EXTINF:(-?\d+),\s*(.+?)\s*-\s*(.+?)\s*$/
            track.duration = Regexp.last_match(1)
            track.creator = Regexp.last_match(2)
            track.title = Regexp.last_match(3)
          else
            if line =~ /^[^#]\S+.+\s*$/
              track.location = line.strip
              playlist.add_track(track)
            end
            track = Playlist::Track.new
          end
        end
      end
    end

    # Generate a M3U file from a [Playlist]
    # @param playlist [Playlist] the playlist to be converted to M3U
    # @return [String] M3U as a string
    def generate(playlist)
      text = "#EXTM3U\n"
      playlist.tracks.each do |t|
        text += "#EXTINF:#{t.duration.to_i},#{t.artist} - #{t.title}\n"
        text += "#{t.location}\n"
      end
      text
    end
  end
end
