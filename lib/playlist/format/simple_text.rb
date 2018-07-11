# Module to parse and generate playlists with one line per track
module Playlist::Format::SimpleText
  class << self
    def parse(input)
      Playlist.new do |playlist|
        input.each_line do |line|
          next if line =~ /^#/

          track = parse_line(line.strip)
          playlist.tracks << track unless track.nil?
        end
      end
    end

    def parse_line(line)
      if line =~ /^(\d{1,2}[:.]\d{1,2}([:.]\d{1,2})?)?\s*(.+?) - (.+?)$/
        Playlist::Track.new(
          :start_time => Regexp.last_match(1),
          :creator => Regexp.last_match(3).strip,
          :title => Regexp.last_match(4).strip
        )
      end
    end

    def generate(playlist)
      playlist.tracks.map { |t| "#{t.creator} - #{t.title}" }.join("\n") + "\n"
    end
  end
end
