require 'playlist/version'

# Data model class that for a single playlist.
class Playlist
  # The title of the playlist
  # @return [String]
  attr_accessor :title

  # The name of the creator of this playlist
  # @return [String]
  attr_accessor :creator

  # A description/synopsis of the playlist
  # @return [String]
  attr_accessor :annotation

  # A URL to get more inforamtion about this playlist
  # @return [String]
  attr_accessor :info_url

  # A link to the license / terms of use for this playlist
  # @return [String]
  attr_accessor :license

  # Get the array that contains the list of track for this playlist
  # @return [Array<Track>] an array of tracks in the playlist
  attr_reader :tracks

  # Create a new Playlist
  # @param attr [Hash] a hash of attibute values to set
  def initialize(attr = {})
    @tracks = []
    attr.each_pair do |key, value|
      send("#{key}=", value)
    end

    yield(self) if block_given?
  end

  # Add a track to the playlist
  # @param args [Track, Hash] either a Track object or
  #        a Hash of attributes to creatre a new Track
  def add_track(args)
    @tracks << (args.is_a?(Track) ? args : Track.new(args))
  end

  # Get the total duration of this playlist
  # If any tracks on the playlist don't have a duation, then they are ignored
  # @return [Integer, Float]
  def duration
    @tracks.map(&:duration).compact.inject(:+)
  end

  autoload :Contributor, 'playlist/contributor'
  autoload :Track, 'playlist/track'
  autoload :Format, 'playlist/format'
end
