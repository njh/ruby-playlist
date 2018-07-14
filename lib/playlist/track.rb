# Data model class that represents a single track
class Playlist::Track
  attr_accessor :location
  attr_accessor :title
  attr_accessor :album

  # The time a track starts playing at, in seconds.
  # May be a Float to include fractions of a second.
  attr_accessor :start_time

  # The duration of the track in seconds.
  # May be a Float to include fractions of a second.
  attr_reader :duration

  # A list of people or groups who contributed to the track
  attr_reader :contributors

  def initialize(attr = {})
    @contributors = []
    attr.each_pair do |key, value|
      send("#{key}=", value)
    end

    yield(self) if block_given?
  end

  def creator
    contributor_names(nil)
  end

  def creator=(name)
    replace_contributor(nil, name)
  end

  # Get a conactinated list of performers for this track
  # If there are no performers, return contributors with no role
  def performer
    contributor_names(:performer) || contributor_names(nil)
  end
  alias artist performer

  def performer=(name)
    replace_contributor(:performer, name)
  end
  alias artist= performer=

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

  def add_contributor(args)
    @contributors << if args.is_a?(Playlist::Contributor)
                       args
                     else
                       Playlist::Contributor.new(args)
                     end
  end

  # First deletes any contribitors with same role, then adds a new contributor
  def replace_contributor(role, name)
    @contributors.delete_if { |c| c.role == role }
    add_contributor(:role => role, :name => name)
  end

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

  def to_h
    Hash[
      instance_variables.map do |v|
        [v.to_s[1..-1].to_sym, instance_variable_get(v)]
      end
    ]
  end
end
