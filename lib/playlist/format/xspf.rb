require 'nokogiri'

unless Nokogiri::XML::Node.respond_to?(:content_at)
  require 'playlist/ext/content_at.rb'
end

# Module to parse and generate XSPF playlists
module Playlist::Format::XSPF
  class << self
    # Parse a XSPF file into a new Playlist object
    # @param input [String, IO] the source of the XSPF file
    # @return [Playlist] a new Playlist object
    def parse(input)
      Playlist.new do |playlist|
        doc = Nokogiri::XML(input)
        playlist.title = doc.content_at('/xmlns:playlist/xmlns:title')
        doc.xpath('/xmlns:playlist/xmlns:trackList/xmlns:track').each do |track|
          playlist.tracks << parse_track(track)
        end
      end
    end

    # Generate a XSPF file from a Playlist object
    # @param playlist [Playlist] the playlist
    # @return [String] the XSPF playlist as a String
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
        track.creator = doc.content_at('./xmlns:creator')
        track.title = doc.content_at('./xmlns:title')
        track.location = doc.content_at('./xmlns:location')
        if (duration = doc.content_at('./xmlns:duration'))
          track.duration = duration.to_i
        end
      end
    end

    def generate_track(xml, track)
      xml.track do
        xml.location(track.location) unless track.location.nil?
        xml.title(track.title) unless track.title.nil?
        xml.creator(track.creator) unless track.creator.nil?
        xml.duration(track.duration) unless track.duration.nil?
      end
    end
  end
end
