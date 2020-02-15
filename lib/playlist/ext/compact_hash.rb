# Monkey patch to add a Hash#compact method
class Hash
  def compact
    select { |_, value| !value.nil? }
  end
end
