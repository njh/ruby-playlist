require 'spec_helper'

describe Playlist::Format::JSPF do
  describe '#parse' do
    describe 'a basic playlist with creator, title and location' do
      let(:playlist) { Playlist::Format::JSPF.parse(fixture('basic.jspf')) }

      it 'parses the title of the playlist' do
        expect(playlist.title).to eq('Basic Playlist')
      end

      it 'parses the title of the playlist' do
        expect(playlist.description).to eq('It is really basic')
      end

      it 'parses 2 tracks from the playlist' do
        expect(playlist.tracks.count).to eq(2)
      end

      it 'parses the creator, title and location from Track 1' do
        expect(playlist.tracks[0].title).to eq('One One One')
        expect(playlist.tracks[0].creator).to eq('Hot Chip')
        expect(playlist.tracks[0].location).to eq('one_one_one.mp3')
        expect(playlist.tracks[0].duration).to eq(215_000)
      end

      it 'parses the creator, title and location from Track 2' do
        expect(playlist.tracks[1].title).to eq('Song 2')
        expect(playlist.tracks[1].creator).to eq('Blur')
        expect(playlist.tracks[1].location).to eq('song2.mp3')
        expect(playlist.tracks[1].duration).to eq(110_000)
      end
    end

    describe 'a playlist with more than the basic set of fields' do
      let(:playlist) do
        data = fixture('comprehensive.jspf')
        Playlist::Format::JSPF.parse(data)
      end

      it 'parses the title of the playlist' do
        expect(playlist.title).to eq('JSPF example')
      end

      it 'parses the creator of the playlist' do
        expect(playlist.creator).to eq('Name of playlist author')
      end

      it 'parses the info URL of the playlist' do
        expect(playlist.info_url).to eq('http://example.com/')
      end

      it 'parses 1 tracks from the playlist' do
        expect(playlist.tracks.count).to eq(1)
      end

      it 'parses track metadata' do
        expect(playlist.tracks[0].title).to eq('Track title')
        expect(playlist.tracks[0].creator).to eq('Artist name')
        expect(playlist.tracks[0].album).to eq('Album name')
        expect(playlist.tracks[0].location).to eq('http://example.com/1.ogg')
        expect(playlist.tracks[0].description).to eq('Some text')
        expect(playlist.tracks[0].duration).to be_nil
        expect(playlist.tracks[0].image).to eq('http://example.com/1.jpg')
      end
    end
  end

  describe '#generate' do
    describe 'a basic tracklist with creator, title and location' do
      let(:json) do
        playlist = Playlist.new
        playlist.title = 'Basic Playlist'
        playlist.description = 'It is really basic'
        playlist.add_track(
          :creator => 'Hot Chip',
          :title => 'One One One',
          :location => 'one_one_one.mp3',
          :duration => 215_000
        )
        playlist.add_track(
          :creator => 'Blur',
          :title => 'Song 2',
          :location => 'song2.mp3',
          :duration => 110_000
        )
        Playlist::Format::JSPF.generate(playlist)
      end

      it 'is equal to the JSON file basic.jspf' do
        expect(json).to eq(fixture('basic.jspf'))
      end
    end
  end
end
