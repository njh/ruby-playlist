require 'nokogiri'

unless Nokogiri::XML::Node.method_defined?(:content_at)
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
        playlist.creator = doc.content_at('/xmlns:playlist/xmlns:creator')
        playlist.description = doc.content_at(
          '/xmlns:playlist/xmlns:annotation'
        )
        playlist.image = doc.content_at('/xmlns:playlist/xmlns:image')
        playlist.info_url = doc.content_at('/xmlns:playlist/xmlns:info')
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
          build_xml_unless_nil(
            xml,
            :title => playlist.title,
            :creator => playlist.creator,
            :annotation => playlist.description,
            :image => playlist.image,
            :info => playlist.info_url
          )
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
        track.location = doc.content_at('./xmlns:location')
        track.title = doc.content_at('./xmlns:title')
        track.creator = doc.content_at('./xmlns:creator')
        if (duration = doc.content_at('./xmlns:duration'))
          track.duration = duration.to_i
        end
        track.album = doc.content_at('./xmlns:album')
        track.description = doc.content_at('./xmlns:annotation')
        track.image = doc.content_at('./xmlns:image')
      end
    end

    def generate_track(xml, track)
      xml.track do
        build_xml_unless_nil(
          xml,
          :location => track.location,
          :title => track.title,
          :creator => track.creator,
          :duration => track.duration,
          :album => track.album,
          :annotation => track.description,
          :image => track.image
        )
      end
    end

    def build_xml_unless_nil(xml, hash)
      hash.each_pair do |key, value|
        xml.send(key, value) unless value.nil?
      end
    end
  end
end
