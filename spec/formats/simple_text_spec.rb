require 'spec_helper'

describe Playlist::Format::SimpleText do
  describe '#parse' do
    describe 'a tracklist with just artist and title' do
      it 'parses each line of a playlist into a seperate track' do
        playlist = Playlist::Format::SimpleText.parse(fixture('simple.txt'))
        expect(playlist.tracks.count).to eq(2)
        expect(playlist.tracks[0].title).to eq('One One One')
        expect(playlist.tracks[0].creator).to eq('Hot Chip')
        expect(playlist.tracks[1].title).to eq('Song 2')
        expect(playlist.tracks[1].creator).to eq('Blur')
      end
    end

    describe 'a tracklist with timestamps' do
      it 'parses each line of a playlist into a seperate track' do
        text = fixture('simple-with-timestamps.txt')
        playlist = Playlist::Format::SimpleText.parse(text)
        expect(playlist.tracks.count).to eq(2)
        expect(playlist.tracks[0].title).to eq('One One One')
        expect(playlist.tracks[0].creator).to eq('Hot Chip')
        expect(playlist.tracks[0].start_time).to eq('00:05')
        expect(playlist.tracks[1].title).to eq('Song 2')
        expect(playlist.tracks[1].creator).to eq('Blur')
        expect(playlist.tracks[1].start_time).to eq('03:41')
      end
    end
  end

  describe '#generate' do
    it 'converts each track in the playlist to a seperate line' do
      playlist = Playlist.new(:title => 'My two-track Playlist')
      playlist.add_track(:title => 'One One One', :creator => 'Hot Chip')
      playlist.add_track(:title => 'Song 2', :creator => 'Blur')

      text = Playlist::Format::SimpleText.generate(playlist)
      expect(text).to eq(fixture('simple.txt'))
    end
  end
end
