require 'spec_helper'

describe Playlist::Format::Cue do
  describe '#parse' do
    describe 'a cue sheet with basic information' do
      let(:playlist) do
        Playlist::Format::Cue.parse(
          fixture('stars-of-cctv.cue')
        )
      end

      it 'parses eight tracks in the cue sheet' do
        expect(playlist.tracks.count).to eq(11)
      end

      it 'parses the title of the cue sheet' do
        expect(playlist.title).to eq('Stars of CCTV')
      end

      it 'parses the media location' do
        expect(playlist.media_location).to eq('stars-of-cctv.mp3')
      end

      it 'parses the track performer, title and start time from Track 1' do
        expect(playlist.tracks[0].track_number).to eq(1)
        expect(playlist.tracks[0].performer).to eq('Hard-Fi')
        expect(playlist.tracks[0].title).to eq('Cash Machine')
        expect(playlist.tracks[0].isrc).to eq('GBAHS0500147')
        expect(playlist.tracks[0].start_time).to eq(0)
      end

      it 'parses the track performer, title and start time from Track 11' do
        expect(playlist.tracks[10].track_number).to eq(11)
        expect(playlist.tracks[10].performer).to eq('Hard-Fi')
        expect(playlist.tracks[10].title).to eq('Stars of CCTV')
        expect(playlist.tracks[10].isrc).to eq('GBAHS0500157')
        expect(playlist.tracks[10].start_time).to eq(2_467_000.0)
      end
    end
  end

  describe '#generate' do
    it 'converts converts a basic playlist to a cue sheet' do
      playlist = Playlist.new(
        :title => 'My Great Playlist',
        :media_location => 'basic.mp3'
      )
      playlist.add_track(
        :title => 'One One One',
        :creator => 'Hot Chip',
        :duration => 215_000
      )
      playlist.add_track(
        :title => 'Song 2',
        :creator => 'Blur',
        :duration => 110_000,
        :isrc => 'GBAYE9600015'
      )

      text = Playlist::Format::Cue.generate(playlist)
      expect(text).to eq(fixture('basic.cue'))
    end
  end
end
