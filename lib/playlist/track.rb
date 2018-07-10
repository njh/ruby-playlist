class Playlist::Track
  attr_accessor :location
  attr_accessor :title
  attr_accessor :creator
  attr_accessor :album
  attr_accessor :start_time
  attr_accessor :duration

  def initialize(attr={})
    attr.each_pair do |key,value|
      self.send("#{key}=", value)
    end

    yield(self) if block_given?
  end

  def to_h
    Hash[
      instance_variables.map { |v|
        [v.to_s[1..-1].to_sym, instance_variable_get(v)]
      }
    ]
  end

end
