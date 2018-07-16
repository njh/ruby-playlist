# Data model class that represents a single track.
class Playlist::Track
  # A URI (or filename) to the location of the file
  attr_accessor :location

  # The title of the track
  # @return [String]
  attr_accessor :title

  # The name of the album that the track came from
  # @return [String]
  attr_accessor :album

  # The number of the track on the album it came from
  # @return [Integer]
  attr_accessor :track_number

  # The side of disc if the track came from a vinyl album (eg A/B)
  # @return [String]
  attr_accessor :side

  # The name of the record label that published the track/album
  # @return [String]
  attr_accessor :record_label

  # The name of the publisher that published the score/lyrics of the song
  # @return [String]
  attr_accessor :publisher

  # The time a track starts playing at, in seconds.
  # May be a Float to include fractions of a second.
  # @return [Integer, Float]
  attr_accessor :start_time

  # The duration of the track in seconds.
  # May be a Float to include fractions of a second.
  # @return [Integer, Float]
  attr_reader :duration

  # Get the array of the contributors to this Track
  # @return [Array<Contributor>] an array of tracks in the playlist
  attr_reader :contributors

  # Create a new Track
  # @param attr [Hash] a hash of attibute values to set
  def initialize(attr = {})
    @contributors = []
    attr.each_pair do |key, value|
      send("#{key}=", value)
    end

    yield(self) if block_given?
  end

  # Get a concatinated list of contributors names with no role
  # @return [String]
  def creator
    contributor_names(nil)
  end

  # Set the name of the contributor with no role
  # Removes any existing contributors with no role
  # @param name [String] the name the contributor
  def creator=(name)
    replace_contributor(nil, name)
  end

  # Get a conactinated list of performers for this track
  # If there are no performers, return contributors with no role
  # @return [String]
  def performer
    contributor_names(:performer) || contributor_names(nil)
  end
  alias artist performer

  # Set the name of the track performer
  # Removes any existing performers
  # @param name [String] the name the performer
  def performer=(name)
    replace_contributor(:performer, name)
  end
  alias artist= performer=

  # Set the duration of the track
  # If the duration is 0 or -1, then the duration is set to nil
  # @param seconds [Numeric] the duration of the track in seconds
  def duration=(seconds)
    if seconds.is_a?(Numeric)
      @duration = seconds
    else
      seconds = seconds.to_s
      @duration = if seconds =~ /\./
                    seconds.to_f
                  else
                    seconds.to_i
                  end
    end
    @duration = nil if [0, -1].include?(@duration)
  end

  # Add a contributor to the Track
  # @param args [Contributor, Hash] either a Contributor object or
  #        a Hash of attributes to creatre a new contributor
  def add_contributor(args)
    @contributors << if args.is_a?(Playlist::Contributor)
                       args
                     else
                       Playlist::Contributor.new(args)
                     end
  end

  # First deletes any contribitors with same role, then adds a new contributor
  # @param role [Symbol] the role of the new contributor
  # @param name [String] the name of the new contributor
  def replace_contributor(role, name)
    @contributors.delete_if { |c| c.role == role }
    add_contributor(:role => role, :name => name)
  end

  # Get a concatinated list of contributor names for a specific role
  # @param role [Symbol] the role of the new contributor
  #             Use :any to concatinate all contributor names
  # @return [String]
  def contributor_names(role = :any)
    filtered = if role == :any
                 @contributors
               else
                 @contributors.find_all { |c| c.role == role }
               end
    if filtered.count == 1
      filtered.first.name
    elsif filtered.count >= 2
      filtered[0..-2].map(&:name).join(', ') +
        ' & ' + filtered.last.name
    end
  end

  # Get all the attributes of the track object as a Hash
  # @return [Hash]
  def to_h
    Hash[
      instance_variables.map do |v|
        [v.to_s[1..-1].to_sym, instance_variable_get(v)]
      end
    ]
  end
end
