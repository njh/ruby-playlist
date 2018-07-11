require 'spec_helper'

describe Playlist do
  describe '#initialize' do
    it 'sets attributes for each pair in hash' do
      playlist = Playlist.new(
        :creator => 'The Creator of Playlists',
        :title => 'Playlist Title'
      )
      expect(playlist.creator).to eq('The Creator of Playlists')
      expect(playlist.title).to eq('Playlist Title')
    end
  end

  describe '#add_track' do
    it 'adds a track to the playlist' do
      playlist = Playlist.new(:title => 'My two-track Playlist')
      playlist.add_track(:title => 'One One One', :creator => 'Hot Chip')
      playlist.add_track(:title => 'Song 2', :creator => 'Blur')
      expect(playlist.tracks.count).to eq(2)
      expect(playlist.tracks.first.title).to eq('One One One')
      expect(playlist.tracks[1].title).to eq('Song 2')
    end
  end
end
