# Base module for the various playlist formats
module Playlist::Format
  autoload :Cue, 'playlist/format/cue'
  autoload :JSPF, 'playlist/format/jspf'
  autoload :M3U, 'playlist/format/m3u'
  autoload :PLS, 'playlist/format/pls'
  autoload :SimpleText, 'playlist/format/simple_text'
  autoload :XSPF, 'playlist/format/xspf'
end
