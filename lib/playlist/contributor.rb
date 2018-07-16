# Data model class that represents a contributor to a track.
# A Contrutor can be a person, or a organisation
# (such an band, choir or orchestra).
class Playlist::Contributor
  # The name of the contributor
  # @return [String]
  attr_accessor :name

  # The role of the contribrition to the track
  #
  # Recommended values for role:
  #   :performer
  #   :composer
  #   :arranger
  #   :lyricist
  # @return [Symbol]
  attr_accessor :role

  # Create a new Contributor
  def initialize(attr = nil)
    if attr.is_a?(Hash)
      attr.each_pair do |key, value|
        send("#{key}=", value)
      end
    elsif attr.is_a?(String)
      self.name = attr
    end

    yield(self) if block_given?
  end
end
