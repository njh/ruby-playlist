require 'spec_helper'

describe Playlist::Format::Dira do
  describe '#parse' do
    describe 'a basic tracklist with artist, title and location' do
      let(:playlist) { Playlist::Format::Dira.parse(fixture('dira-mix.xml')) }

      it 'parses the title of the playlist' do
        expect(playlist.title).to eq('My brilliant Music Mix Public Title')
      end

      it 'parses 2 tracks from the playlist' do
        expect(playlist.tracks.count).to eq(2)
      end

      it 'parses the metadata for Track 1' do
        expect(playlist.tracks[0].title).to eq('Back For The First Time')
        expect(playlist.tracks[0].performer).to eq('Caspa')
        expect(playlist.tracks[0].album).to eq('Alpha Omega')
        expect(playlist.tracks[0].catalogue_number).to eq('643157426073')
        expect(playlist.tracks[0].record_label).to eq('Dub Police')
        expect(playlist.tracks[0].track_number).to eq('015')
        expect(playlist.tracks[0].duration).to eq(276.192)
      end

      it 'parses the metadata for Track 2' do
        expect(playlist.tracks[1].title).to eq('Bad Habit')
        expect(playlist.tracks[1].performer).to eq('Foals')
        expect(playlist.tracks[1].album).to be_nil
        expect(playlist.tracks[1].record_label).to be_nil
        expect(playlist.tracks[1].track_number).to be_nil
        expect(playlist.tracks[1].duration).to eq(265.055)
      end
    end
  end
end
