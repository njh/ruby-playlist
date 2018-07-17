require 'spec_helper'

describe Playlist::Format::Cue do
  describe '#parse' do
    describe 'a cue sheet with basic information' do
      let(:playlist) { Playlist::Format::Cue.parse(fixture('faithless.cue')) }

      it 'parses eight tracks in the cue sheet' do
        expect(playlist.tracks.count).to eq(8)
      end

      it 'parses the title of the cue sheet' do
        expect(playlist.title).to eq('Live in Berlin')
      end

      it 'parses the media location' do
        expect(playlist.media_location).to eq('Faithless - Live in Berlin.mp3')
      end

      it 'parses the track performer, title and start time from Track 1' do
        expect(playlist.tracks[0].track_number).to eq(1)
        expect(playlist.tracks[0].performer).to eq('Faithless')
        expect(playlist.tracks[0].title).to eq('Reverence')
        expect(playlist.tracks[0].start_time).to eq(0)
      end

      it 'parses the track performer, title and start time from Track 8' do
        expect(playlist.tracks[7].track_number).to eq(8)
        expect(playlist.tracks[7].performer).to eq('Faithless')
        expect(playlist.tracks[7].title).to eq('God Is a DJ')
        expect(playlist.tracks[7].start_time).to eq(2555)
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
        :duration => 215
      )
      playlist.add_track(
        :title => 'Song 2',
        :creator => 'Blur',
        :duration => 110
      )

      text = Playlist::Format::Cue.generate(playlist)
      expect(text).to eq(fixture('basic.cue'))
    end
  end
end
