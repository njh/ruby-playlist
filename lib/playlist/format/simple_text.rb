# Module to parse and generate playlists with one line per track
module Playlist::Format::SimpleText
  class << self
    # Parse a human readable list of tracks into a Playlist
    # @param input any object that responds to #each_line
    #        (either a String or a IO object)
    # @return [Playlist] a new Playlist object
    def parse(input)
      Playlist.new do |playlist|
        input.each_line do |line|
          next if line =~ /^#/

          track = parse_line(line.strip)
          playlist.tracks << track unless track.nil?
        end
      end
    end

    # Parse a single line from a playlist into a Track obect
    # @param line [String] any object that responds to #each_line
    # @return [Track] a new Track object
    def parse_line(line)
      if line =~ /^(\d{1,2}[:.]\d{1,2}([:.]\d{1,2})?)?\s*(.+?) - (.+?)$/
        Playlist::Track.new(
          :start_time => Regexp.last_match(1),
          :creator => Regexp.last_match(3).strip,
          :title => Regexp.last_match(4).strip
        )
      end
    end

    # Generate a human readable list of tracks from a Playlist
    # @param playlist [Playlist] the playlist
    # @return [String] the playlist with one line per track
    def generate(playlist)
      playlist.tracks.map { |t| "#{t.artist} - #{t.title}" }.join("\n") + "\n"
    end
  end
end
