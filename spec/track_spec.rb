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

  describe '#duration=' do
    let(:track) { Playlist::Track.new }

    it 'should set duration to nil if the value is 0' do
      track.duration = 0
      expect(track.duration).to be_nil
    end

    it 'should set duration to nil if the value is -1' do
      track.duration = 0
      expect(track.duration).to be_nil
    end

    it 'should convert a string duration to an integer' do
      track.duration = '140'
      expect(track.duration).to eq(140)
      expect(track.duration).to be_a(Integer)
    end

    it 'should convert a decimal string duration to a float' do
      track.duration = '234.776'
      expect(track.duration).to eq(234.776)
      expect(track.duration).to be_a(Float)
    end
  end

  describe '#to_h' do
    it 'returns all the track attributes as a Hash' do
      attr = {
        :location => 'filename.mp3',
        :title => 'Track Title',
        :duration => 10
      }
      track = Playlist::Track.new(attr)
      expect(track.to_h).to eq(attr)
    end
  end
end
