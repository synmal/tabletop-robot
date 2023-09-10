require 'spec_helper'
require_relative '../tabletop'

describe Tabletop do
  context 'valid_position?' do
    subject { described_class.new(width: 3, height: 3) }

    it 'should return true if position is in range' do
      expect(subject.valid_position?(x: 1, y: 2)).to be_truthy
      expect(subject.valid_position?(x: 3, y: 3)).to be_truthy
      expect(subject.valid_position?(x: 0, y: 0)).to be_truthy
    end

    it 'should return true if position is in range' do
      expect(subject.valid_position?(x: -1, y: -1)).to be_falsy
      expect(subject.valid_position?(x: 4, y: 4)).to be_falsy
    end
  end
end