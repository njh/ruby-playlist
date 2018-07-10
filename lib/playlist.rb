require 'playlist/version'

class Playlist
  attr_accessor :title
  attr_accessor :creator
  attr_accessor :annotation
  attr_accessor :info_url
  attr_accessor :identifiers
  attr_accessor :license

  attr_reader :tracks

  def initialize(attr={})
    @tracks = []
    attr.each_pair do |key,value|
      self.send("#{key}=", value)
    end

    yield(self) if block_given?
  end

  def add_track(args)
    if args.is_a?(Track)
      @tracks << args
    else
      @tracks << Track.new(args)
    end
  end

  autoload :Track, 'playlist/track'
end
