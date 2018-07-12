# Data model class that represents a single track
class Playlist::Track
  attr_accessor :location
  attr_accessor :title
  attr_accessor :creator
  attr_accessor :album
  attr_accessor :start_time

  # The duration of the track in seconds.
  # May be a Float to include fractions of a second.
  attr_accessor :duration

  def initialize(attr = {})
    attr.each_pair do |key, value|
      send("#{key}=", value)
    end

    yield(self) if block_given?
  end

  def artist
    @creator
  end

  def artist=(artist)
    @creator = artist
  end

  def to_h
    Hash[
      instance_variables.map do |v|
        [v.to_s[1..-1].to_sym, instance_variable_get(v)]
      end
    ]
  end
end
