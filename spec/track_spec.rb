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

  describe '#identifiers' do
    let(:track) { Playlist::Track.new }

    it 'is initially an empty Hash' do
      expect(track.identifiers).to be_a(Hash)
      expect(track.identifiers).to be_empty
    end

    it 'allows new identifiers to be set' do
      track.identifiers[:take_id] = '866932FA'
      expect(track.identifiers[:take_id]).to eq('866932FA')
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
      track.duration = '140000'
      expect(track.duration).to eq(140_000)
      expect(track.duration).to be_a(Integer)
    end

    it 'should convert a decimal string duration to a float' do
      track.duration = '234000.776'
      expect(track.duration).to eq(234_000.776)
      expect(track.duration).to be_a(Float)
    end
  end

  describe '#isrc' do
    let(:track) { Playlist::Track.new(:title => 'Let Me Live') }

    it 'should return nil if there is no isrc' do
      expect(track.composer).to be_nil
    end

    it 'should allow setting and returning the ISRC' do
      track.isrc = 'GBAHS1800368'
      expect(track.isrc).to eq('GBAHS1800368')
    end

    it 'should replace one ISRC with another' do
      track.isrc = 'GBAHS1800488'
      track.isrc = 'GBAHS1800368'
      expect(track.isrc).to eq('GBAHS1800368')
    end

    it 'should be able to fetch ISRC via identifiers hash' do
      track.isrc = 'GBAHS1800368'
      expect(track.identifiers[:isrc]).to eq('GBAHS1800368')
    end
  end

  describe '#add_contributor=' do
    let(:track) { Playlist::Track.new }

    it 'should add a contributor with an object' do
      contributor = Playlist::Contributor.new(:name => 'A Contibutor')
      track.add_contributor(contributor)
      expect(track.contributors.count).to eq(1)
      expect(track.contributors.first.name).to eq('A Contibutor')
    end

    it 'should add a contributor with a name and role' do
      track.add_contributor(:name => 'Jamie xx', :role => :performer)
      expect(track.contributors.count).to eq(1)
      expect(track.contributors.first.name).to eq('Jamie xx')
      expect(track.contributors.first.role).to eq(:performer)
    end

    it 'should add a contributor with just a name' do
      track.add_contributor('A Contibutor')
      expect(track.contributors.count).to eq(1)
      expect(track.contributors.first.name).to eq('A Contibutor')
      expect(track.contributors.first.role).to be_nil
    end
  end

  describe '#contributor_names' do
    let(:track) { Playlist::Track.new(:title => 'Let Me Live') }

    it 'should return nil if there are no contributors' do
      expect(track.contributor_names).to be_nil
    end

    it 'should join the names together a single performer' do
      track.add_contributor(:name => 'Rudimental', :role => :performer)
      expect(track.contributors.count).to eq(1)
      expect(track.contributor_names).to eq('Rudimental')
    end

    it 'should join the names together for two performers' do
      track.add_contributor(:name => 'Rudimental', :role => :performer)
      track.add_contributor(:name => 'Major Lazer', :role => :performer)
      expect(track.contributors.count).to eq(2)
      expect(track.contributor_names).to eq('Rudimental & Major Lazer')
    end

    it 'should join the names together for three performers' do
      track.add_contributor(:name => 'Rudimental', :role => :performer)
      track.add_contributor(:name => 'Major Lazer', :role => :performer)
      track.add_contributor(:name => 'Anne‐Marie', :role => :performer)
      expect(track.contributors.count).to eq(3)
      expect(track.contributor_names).to eq(
        'Rudimental, Major Lazer & Anne‐Marie'
      )
    end

    it 'should join the names together for four performers' do
      track.add_contributor(:name => 'Rudimental', :role => :performer)
      track.add_contributor(:name => 'Major Lazer', :role => :performer)
      track.add_contributor(:name => 'Anne‐Marie', :role => :performer)
      track.add_contributor(:name => 'Mr. Eazi', :role => :performer)
      expect(track.contributors.count).to eq(4)
      expect(track.contributor_names).to eq(
        'Rudimental, Major Lazer, Anne‐Marie & Mr. Eazi'
      )
    end

    it 'should filter the contributors if a role is given' do
      track.add_contributor(:name => 'Rudimental', :role => :performer)
      track.add_contributor(:name => 'Amir Izadkhah', :role => :composer)
      expect(track.contributors.count).to eq(2)
      expect(track.contributor_names(:performer)).to eq('Rudimental')
      expect(track.contributor_names(:composer)).to eq('Amir Izadkhah')
      expect(track.contributor_names(:any)).to eq('Rudimental & Amir Izadkhah')
    end

    it 'should filter the contributors without a role if nil is given' do
      track.add_contributor('Rudimental')
      track.add_contributor('Major Lazer')
      track.add_contributor(:name => 'Amir Izadkhah', :role => :composer)
      expect(track.contributors.count).to eq(3)
      expect(track.contributor_names(nil)).to eq('Rudimental & Major Lazer')
    end
  end

  describe '#creator' do
    let(:track) { Playlist::Track.new(:title => 'Let Me Live') }

    it 'should return nil if there is no creator' do
      expect(track.creator).to be_nil
    end

    it 'should allow setting and returning the creator name' do
      track.creator = 'Rudimental'
      expect(track.creator).to eq('Rudimental')
    end

    it 'should return the performer name, if there is one set' do
      track.performer = 'Rudimental'
      expect(track.creator).to eq('Rudimental')
    end

    it 'should return the composer name, if there is one set' do
      track.composer = 'Amir Izadkhah'
      expect(track.creator).to eq('Amir Izadkhah')
    end

    it 'should return both the composer and performer names' do
      track.performer = 'Rudimental'
      track.composer = 'Amir Izadkhah'
      expect(track.creator).to eq('Rudimental & Amir Izadkhah')
    end

    it 'should replace one creator name with another' do
      track.creator = 'Major Lazer'
      track.creator = 'Rudimental'
      expect(track.creator).to eq('Rudimental')
    end
  end

  describe '#performer' do
    let(:track) { Playlist::Track.new(:title => 'Let Me Live') }

    it 'should return nil if there are no performers' do
      expect(track.performer).to be_nil
    end

    it 'should allow setting and returning the performer name' do
      track.performer = 'Rudimental'
      expect(track.performer).to eq('Rudimental')
    end

    it 'should allow using the #artist alias' do
      track.artist = 'Rudimental'
      expect(track.artist).to eq('Rudimental')
      expect(track.creator).to eq('Rudimental')

      track.artist = 'New Rudimental'
      expect(track.artist).to eq('New Rudimental')
      expect(track.creator).to eq('New Rudimental')
    end

    it 'should replace one performer name with another' do
      track.performer = 'Major Lazer'
      track.performer = 'Rudimental'
      expect(track.performer).to eq('Rudimental')
    end
  end

  describe '#composer' do
    let(:track) { Playlist::Track.new(:title => 'Let Me Live') }

    it 'should return nil if there is no composer' do
      expect(track.composer).to be_nil
    end

    it 'should allow setting and returning the composer name' do
      track.composer = 'Amir Izadkhah'
      expect(track.composer).to eq('Amir Izadkhah')
    end

    it 'should replace one composer name with another' do
      track.composer = 'Incorrect composer'
      track.composer = 'Amir Izadkhah'
      expect(track.composer).to eq('Amir Izadkhah')
    end
  end

  describe '#arranger' do
    let(:track) { Playlist::Track.new(:title => 'The Lion King') }

    it 'should return nil if there is no arranger' do
      expect(track.arranger).to be_nil
    end

    it 'should allow setting and returning the arranger' do
      track.arranger = 'John Higgins'
      expect(track.arranger).to eq('John Higgins')
    end

    it 'should replace one arranger name with another' do
      track.arranger = 'Incorrect arranger'
      track.arranger = 'John Higgins'
      expect(track.arranger).to eq('John Higgins')
    end
  end

  describe '#to_h' do
    it 'returns all the track attributes as a Hash' do
      attr = {
        :location => 'filename.mp3',
        :title => 'Track Title',
        :duration => 10_000
      }
      track = Playlist::Track.new(attr)
      expect(track.to_h).to eq(
        attr.merge(
          :contributors => [],
          :identifiers => {}
        )
      )
    end
  end
end
