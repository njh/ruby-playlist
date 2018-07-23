require 'nokogiri'

unless Nokogiri::XML::Node.respond_to?(:content_at)
  require 'playlist/ext/content_at.rb'
end

# Module to parse Scisys dira XML genealogy files
module Playlist::Format::Dira
  class << self
    # Parse a Dira XML document into a new Playlist object
    # @param input [String, IO] the source of the Dira XML
    # @return [Playlist] a new Playlist object
    def parse(input)
      Playlist.new do |playlist|
        doc = Nokogiri::XML(input)
        playlist.title = doc.content_at(
          '//TAKE/GENERIC/GENE_MULTIMEDIA_TITLE'
        ) || doc.content_at(
          '//TAKE/GENERIC/GENE_TITLE'
        )
        doc.xpath('//TAKE/GENEALOGY/GENEALOGY_ITEM').each do |item|
          playlist.tracks << parse_genealogy_item(item)
        end
      end
    end

    protected

    # Parse a single Genealogy Item from a Dira XML document
    def parse_genealogy_item(doc)
      Playlist::Track.new do |track|
        track.title = doc.content_at('./CLIP/CLIP_INFO/GENE_TITLE')
        track.album = doc.content_at('./CLIP/CLIP_INFO/GENE_ALBUM')
        track.catalogue_number = doc.content_at('./CLIP/CLIP_INFO/GENE_EAN')
        track.track_number = doc.content_at('./CLIP/CLIP_INFO/GENE_TRACK')
        track.side = doc.content_at('./CLIP/CLIP_INFO/GENE_SIDE')
        track.record_label = doc.content_at('./CLIP/CLIP_INFO/GENE_LABEL')
        track.publisher = doc.content_at('./CLIP/CLIP_INFO/GENE_PUBLISHER')
        if (duration = doc.content_at('./GENY_CLIP_LENGTH'))
          track.duration = duration.to_f / 1000
        end
        doc.xpath('./CLIP/CLIP_PERSONS/PERSON').each do |person|
          track.contributors << parse_person(person)
        end
      end
    end

    # Parse a single Person from a dira XML document
    def parse_person(doc)
      Playlist::Contributor.new do |c|
        c.name = doc.content_at('PERSON_NAME')
        if doc.content_at('PMAP_FUNC') =~ /^PERSON_FUNC\$(.+)\#(.*)$/
          c.role = Regexp.last_match(1).downcase.to_sym
        end
      end
    end
  end
end
