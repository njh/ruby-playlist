require 'spec_helper'

describe Playlist::Contributor do
  describe '#initialize' do
    it 'sets attributes for each pair in hash' do
      contributor = Playlist::Contributor.new(
        :name => 'Jamie xx',
        :role => :performer
      )
      expect(contributor.name).to eq('Jamie xx')
      expect(contributor.role).to eq(:performer)
    end

    it 'sets the name if a string is given' do
      contributor = Playlist::Contributor.new('Blur')
      expect(contributor.name).to eq('Blur')
      expect(contributor.role).to be_nil
    end
  end
end
