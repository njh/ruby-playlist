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

  describe '#identifiers' do
    let(:playlist) { Playlist.new }

    it 'is initially an empty Hash' do
      expect(playlist.identifiers).to be_a(Hash)
      expect(playlist.identifiers).to be_empty
    end

    it 'allows new identifiers to be set' do
      playlist.identifiers[:take_id] = '866932FA'
      expect(playlist.identifiers[:take_id]).to eq('866932FA')
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

  describe '#duration' do
    it 'should return the total duration of a playlist' do
      playlist = Playlist.new
      playlist.add_track(:duration => 215, :title => 'One One One')
      playlist.add_track(:duration => 110, :title => 'Song 2')
      expect(playlist.duration).to eq(325)
    end

    it 'should ignore tracks that have no duration' do
      playlist = Playlist.new
      playlist.add_track(:duration => 215, :title => 'One One One')
      playlist.add_track(:duration => 110, :title => 'Song 2')
      playlist.add_track(:duration => nil, :title => 'Unknown')
      expect(playlist.duration).to eq(325)
    end
  end
end
