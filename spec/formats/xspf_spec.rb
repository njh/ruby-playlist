require 'spec_helper'

describe Playlist::Format::XSPF do
  describe '#parse' do
    describe 'a basic tracklist with artist, title and location' do
      let(:playlist) { Playlist::Format::XSPF.parse(fixture('basic.xspf')) }

      it 'parses the title of the playlist' do
        expect(playlist.title).to eq('Basic Playlist')
      end

      it 'parses 2 tracks from the playlist' do
        expect(playlist.tracks.count).to eq(2)
      end

      it 'parses the artist, title and location from Track 1' do
        expect(playlist.tracks[0].title).to eq('One One One')
        expect(playlist.tracks[0].creator).to eq('Hot Chip')
        expect(playlist.tracks[0].location).to eq('one_one_one.mp3')
        expect(playlist.tracks[0].duration).to eq(215)
      end

      it 'parses the artist, title and location from Track 2' do
        expect(playlist.tracks[1].title).to eq('Song 2')
        expect(playlist.tracks[1].creator).to eq('Blur')
        expect(playlist.tracks[1].location).to eq('song2.mp3')
        expect(playlist.tracks[1].duration).to eq(110)
      end
    end
  end

  describe '#generate' do
    describe 'a basic tracklist with artist, title and location' do
      let(:xml) do
        playlist = Playlist.new
        playlist.title = 'Basic Playlist'
        playlist.add_track(
          :creator => 'Hot Chip',
          :title => 'One One One',
          :location => 'one_one_one.mp3',
          :duration => 215.0
        )
        playlist.add_track(
          :creator => 'Blur',
          :title => 'Song 2',
          :location => 'song2.mp3',
          :duration => 110.0
        )
        Playlist::Format::XSPF.generate(playlist)
      end

      it 'is equivelent to the XML file basic.xspf' do
        expect(xml).to be_equivalent_to(fixture('basic.xspf'))
      end
    end
  end
end
