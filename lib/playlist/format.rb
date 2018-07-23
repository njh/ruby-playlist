# Base module for the various playlist formats
module Playlist::Format
  autoload :Cue, 'playlist/format/cue'
  autoload :M3U, 'playlist/format/m3u'
  autoload :SimpleText, 'playlist/format/simple_text'
  autoload :XSPF, 'playlist/format/xspf'
end
