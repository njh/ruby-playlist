# Module to parse and generate M3U playlists
module Playlist::Format::M3U
  class << self
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
