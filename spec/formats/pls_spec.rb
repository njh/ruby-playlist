require 'spec_helper'

describe Playlist::Format::PLS do
  describe '#parse' do
    describe 'a playlist of two tracks' do
      let(:playlist) { Playlist::Format::PLS.parse(fixture('basic.pls')) }

      it 'parses two tracks in the tracklist' do
        expect(playlist.tracks.count).to eq(2)
      end

      it 'parses the duration, artist, title and location from Track 1' do
        expect(playlist.tracks[0].creator).to eq('Hot Chip')
        expect(playlist.tracks[0].title).to eq('One One One')
        expect(playlist.tracks[0].duration).to eq(215_000)
        expect(playlist.tracks[0].location).to eq('one_one_one.mp3')
      end

      it 'parses the duration, artist, title and location from Track 2' do
        expect(playlist.tracks[1].creator).to eq('Blur')
        expect(playlist.tracks[1].title).to eq('Song 2')
        expect(playlist.tracks[1].duration).to eq(110_000)
        expect(playlist.tracks[1].location).to eq('song2.mp3')
      end
    end
  end

  describe '#generate' do
    it 'converts each track in the playlist to valid PLS file' do
      playlist = Playlist.new
      playlist.add_track(
        :location => 'one_one_one.mp3',
        :title => 'One One One',
        :creator => 'Hot Chip',
        :duration => 215_000
      )
      playlist.add_track(
        :location => 'song2.mp3',
        :title => 'Song 2',
        :creator => 'Blur',
        :duration => 110_000
      )

      text = Playlist::Format::PLS.generate(playlist)
      expect(text).to eq(fixture('basic.pls'))
    end

    it 'creates valid PLS file, if there is no artist/creator' do
      playlist = Playlist.new
      playlist.add_track(
        :location => 'not_really_music.mp3',
        :title => 'This is the Title',
        :duration => 7_200_123
      )

      text = Playlist::Format::PLS.generate(playlist)
      expect(text).to eq(fixture('no_artist.pls'))
    end
  end
end
