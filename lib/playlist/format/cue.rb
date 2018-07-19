# Module to parse and generate Cue Sheet file format
module Playlist::Format::Cue
  class << self
    # Parse a Cue Sheet file into a [Playlist]
    # @param input any object that responds to #each_line
    #        (either a String or a IO object)
    # @return [Playlist] a new Playlist object
    def parse(input)
      Playlist.new do |playlist|
        track = nil
        input.each_line do |line|
          if line =~ /^\s*REM\s/
            next
          elsif line =~ /^\s*TRACK (\d+) AUDIO/
            track = Playlist::Track.new(
              :track_number => Regexp.last_match(1).to_i
            )
            playlist.add_track(track)
          elsif !track.nil?
            parse_track_line(track, line.strip)
          else
            parse_playlist_line(playlist, line.strip)
          end
        end
      end
    end

    # Generate a human readable list of tracks from a Playlist
    # @param playlist [Playlist] the playlist
    # @return [String] the playlist with one line per track
    def generate(playlist)
      text = ''
      playlist.calculate_start_times
      text += generate_line(0, 'TITLE', playlist.title)
      text += generate_line(
        0, 'FILE', format_filename(playlist.media_location), false
      )
      playlist.tracks.each_with_index do |track, index|
        text += generate_track(track, index + 1)
      end
      text
    end

    protected

    def parse_track_line(track, line)
      if line =~ /^\s*TITLE \"?(.+?)\"?$/
        track.title = Regexp.last_match(1)
      elsif line =~ /^\s*PERFORMER \"?(.+?)\"?$/
        track.performer = Regexp.last_match(1)
      elsif line =~ /^\s*INDEX /
        track.start_time = parse_time(line)
      else
        warn "Unknown command: #{line}"
      end
    end

    def parse_playlist_line(playlist, line)
      if line =~ /^\s*TITLE \"?(.+?)\"?$/
        playlist.title = Regexp.last_match(1)
      elsif line =~ /^\s*FILE \"?(.+?)\" (\w+)?$/
        playlist.media_location = Regexp.last_match(1)
      end
    end

    def generate_track(track, track_num)
      text = ''
      text += generate_line(1, 'TRACK', format('%2.2d AUDIO', track_num), false)
      text += generate_line(2, 'TITLE', track.title)
      text += generate_line(2, 'PERFORMER', track.performer)
      text += generate_line(2, 'INDEX 01', format_time(track.start_time), false)
      text
    end

    def generate_line(depth, name, value, escape = true)
      if value.nil?
        ''
      else
        space = '  ' * depth
        if escape
          escaped = value.tr('"', "'")
          "#{space}#{name} \"#{escaped}\"\n"
        else
          "#{space}#{name} #{value}\n"
        end
      end
    end

    def parse_time(timestamp)
      if timestamp =~ /INDEX (\d+) (\d+):(\d+):(\d+)/
        if Regexp.last_match(1).to_i == 1
          mins = Regexp.last_match(2).to_f
          secs = Regexp.last_match(3).to_f
          frames = Regexp.last_match(4).to_f
          (mins * 60) + secs + (frames / 75)
        end
      end
    end

    def format_time(duration)
      duration = 0 if duration.nil?
      mins = (duration / 60).floor
      secs = (duration % 60).floor
      frames = ((duration - duration.floor) * 75).round
      format('%2.2d:%2.2d:%2.2d', mins, secs, frames)
    end

    def format_filename(location)
      filename = File.basename(location)
      fmt = File.extname(filename)[1..-1].upcase
      "\"#{filename}\" #{fmt}"
    end
  end
end
