# Base module for the various playlist formats
module Playlist::Format
  autoload :SimpleText, 'playlist/format/simple_text'
  autoload :XSPF, 'playlist/format/xspf'
end
