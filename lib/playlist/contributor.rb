# Data model class that represents a contributor to a track
class Playlist::Contributor
  attr_accessor :name
  attr_accessor :role

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
