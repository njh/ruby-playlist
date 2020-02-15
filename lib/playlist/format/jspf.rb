require 'json'

require 'playlist/ext/compact_hash.rb' unless Hash.method_defined?(:compact)

# Module to parse and generate JSPF playlists
module Playlist::Format::JSPF
  class << self
    # Parse a JSPF file into a new Playlist object
    # @param input [String, IO] the source of the JSPF file
    # @return [Playlist] a new Playlist object
    def parse(input)
      Playlist.new do |playlist|
        doc = JSON.parse(input)
        top = doc['playlist']
        raise "JSPF missing top-level 'playlist' object" if top.nil?

        playlist.title = top['title']
        playlist.creator = top['creator']
        playlist.description = top['annotation']
        playlist.image = top['image']
        playlist.info_url = top['info']
        if top['track'].is_a?(Array)
          top['track'].each { |track| playlist.add_track parse_track(track) }
        end
      end
    end

    # Generate a JSPF file from a Playlist object
    # @param playlist [Playlist] the playlist
    # @return [String] the JSPF playlist as a String
    def generate(playlist)
      result = {
        :title => playlist.title,
        :creator => playlist.creator,
        :annotation => playlist.description,
        :image => playlist.image,
        :info => playlist.info_url
      }.compact
      result[:track] = playlist.tracks.map { |track| generate_track(track) }
      JSON.pretty_generate('playlist' => result) + "\n"
    end

    protected

    def parse_track(doc)
      Playlist::Track.new do |track|
        track.location = if doc['location'].is_a?(Enumerable)
                           doc['location'].first
                         else
                           doc['location']
                         end
        track.title = doc['title']
        track.creator = doc['creator']
        track.duration = doc['duration'].to_i unless doc['duration'].nil?
        track.album = doc['album']
        track.description = doc['annotation']
        track.image = doc['image']
      end
    end

    def generate_track(track)
      location = [track.location] unless track.location.nil?
      {
        :location => location,
        :title => track.title,
        :creator => track.creator,
        :duration => track.duration,
        :album => track.album,
        :annotation => track.description,
        :image => track.image
      }.compact
    end
  end
end
