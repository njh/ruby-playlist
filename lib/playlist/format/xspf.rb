require 'nokogiri'

# Module to parse and generate XSPF playlists
module Playlist::Format::XSPF
  class << self
    def parse(input)
      Playlist.new do |playlist|
        doc = Nokogiri::XML(input)
        playlist.title = inner_text_or_nil(doc, '/xmlns:playlist/xmlns:title')
        doc.xpath('/xmlns:playlist/xmlns:trackList/xmlns:track').each do |track|
          playlist.tracks << parse_track(track)
        end
      end
    end

    def generate(playlist)
      builder = Nokogiri::XML::Builder.new do |xml|
        xml.playlist(:version => 1, :xmlns => 'http://xspf.org/ns/0/') do
          xml.title(playlist.title) unless playlist.title.nil?
          xml.trackList do
            playlist.tracks.each { |track| generate_track(xml, track) }
          end
        end
      end
      builder.to_xml
    end

    protected

    def parse_track(doc)
      Playlist::Track.new do |track|
        track.creator = inner_text_or_nil(doc, 'creator')
        track.title = inner_text_or_nil(doc, 'title')
        track.location = inner_text_or_nil(doc, 'location')
      end
    end

    def generate_track(xml, track)
      xml.track do
        xml.location(track.location) unless track.location.nil?
        xml.title(track.title) unless track.title.nil?
        xml.creator(track.creator) unless track.creator.nil?
      end
    end

    ## FIXME: how to do this better?
    def inner_text_or_nil(doc, path)
      element = doc.at(path)
      element.inner_text unless element.nil?
    end
  end
end
