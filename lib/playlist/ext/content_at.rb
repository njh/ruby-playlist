# Monkey patch to add a #content_at method
class Nokogiri::XML::Node
  def content_at(*args)
    node = at(*args)
    node&.content
  end
end
