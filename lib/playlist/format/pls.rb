# Module to parse and generate PLS playlists
module Playlist::Format::PLS
  class << self
    # Parse a PLS file into a [Playlist]
    # @param input any object that responds to #each_line
    #        (either a String or a IO object)
    # @return [Playlist] a new Playlist object
    def parse(input)
      tracks = parse_lines_to_array(input)

      # Now convert to objects
      array_to_object(tracks)
    end

    # Generate a PLS file from a [Playlist]
    # @param playlist [Playlist] the playlist to be converted to PLS
    # @return [String] PLS as a string
    def generate(playlist)
      text = "[playlist]\n\n"
      playlist.tracks.each_with_index do |t, index|
        index += 1
        duration = (t.duration / 1000).round
        text += "File#{index}=#{t.location}\n"
        if t.creator && t.title
          text += "Title#{index}=#{t.creator} - #{t.title}\n"
        elsif t.title
          text += "Title#{index}=#{t.title}\n"
        end
        text += "Length#{index}=#{duration}\n"
        text += "\n"
      end
      text += "NumberOfEntries=#{playlist.tracks.count}\n"
      text += "Version=2\n"
      text
    end

    protected

    def parse_line(tracks, line)
      if (matches = line.match(/^([a-z]+)(\d+)=(.+)$/i))
        key = matches[1].downcase.to_sym
        num = matches[2].to_i - 1
        tracks[num] ||= {}
        tracks[num][key] = matches[3]
      elsif (matches = line.match(/^NumberOfEntries=(\d+)$/))
        if matches[1].to_i != tracks.count
          raise 'PLS parse error: NumberOfEntries is incorrect'
        end
      elsif (matches = line.match(/^Version=(\d+)$/))
        if matches[1] != '2'
          raise "PLS file version #{version} is not supported"
        end
      else
        warn "Unable to parse line: #{line}"
      end
    end

    def parse_lines_to_array(input)
      tracks = []
      input.each_line.with_index do |line, index|
        line.strip!
        if index.zero?
          if line == '[playlist]'
            next
          else
            raise 'PLS parse error: first line is not [playlist]'
          end
        end
        parse_line(tracks, line) unless line.empty?
      end
      tracks
    end

    def array_to_object(tracks)
      Playlist.new do |playlist|
        tracks.each do |track|
          obj = Playlist::Track.new
          obj.location = track[:file] unless track[:file].nil?
          obj.duration = track[:length].to_i * 1000 unless track[:length].nil?
          if (matches = track[:title].match(/^(.+) - (.+)$/))
            obj.creator = matches[1]
            obj.title = matches[2]
          else
            obj.title = track[:title]
          end
          playlist.add_track(obj)
        end
      end
    end
  end
end
