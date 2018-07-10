require 'spec_helper'

describe Playlist::Track do
  describe '#initialize' do
    it 'sets attributes for each pair in hash' do
      track = Playlist::Track.new(
        :location => 'filename.mp3',
        :title => 'Track Title'
      )
      expect(track.location).to eq('filename.mp3')
      expect(track.title).to eq('Track Title')
    end
  end

  describe '#to_h' do
    it 'returns all the track attributes as a Hash' do
      attr = {:location => 'filename.mp3', :title => 'Track Title', :duration => 10}
      track = Playlist::Track.new(attr)
      expect(track.to_h).to eq(attr)
    end
  end
end
