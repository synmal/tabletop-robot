require 'spec_helper'
require_relative '../robot'
require_relative '../tabletop'

describe Robot do
  subject { Robot.new(tabletop: Tabletop.new(width: 5, height: 5)) }
  context 'place' do
    it 'should place robot with the correct coordinates' do
      expect { subject.place(x: 0, y: 0, facing: 'north') }
        .to change { subject.x }.to(0)
        .and change { subject.y }.to(0)
        .and change { subject.facing }.to('north')
    end

    it 'should raise error if coordinates is out of bound' do
      expect { subject.place(x: -1, y: 0, facing: 'north') }.to raise_error(Robot::Error)
      expect { subject.place(x: 0, y: -1, facing: 'north') }.to raise_error(Robot::Error)
      expect { subject.place(x: 6, y: 0, facing: 'north') }.to raise_error(Robot::Error)
      expect { subject.place(x: 0, y: 6, facing: 'north') }.to raise_error(Robot::Error)
      expect { subject.place(x: 0, y: 0, facing: 'north west') }.to raise_error(Robot::Error)
    end
  end

  context 'left' do
    it 'should face west if from north' do
      subject.place(x: 0, y: 0, facing: 'north')
      expect { subject.left }.to change { subject.facing }.from('north').to('west')
    end

    it 'should face south if from west' do
      subject.place(x: 0, y: 0, facing: 'west')
      expect { subject.left }.to change { subject.facing }.from('west').to('south')
    end

    it 'should face east if from south' do
      subject.place(x: 0, y: 0, facing: 'south')
      expect { subject.left }.to change { subject.facing }.from('south').to('east')
    end

    it 'should face north if from east' do
      subject.place(x: 0, y: 0, facing: 'east')
      expect { subject.left }.to change { subject.facing }.from('east').to('north')
    end
  end

  context 'right' do
    it 'should face east if from north' do
      subject.place(x: 0, y: 0, facing: 'north')
      expect { subject.right }.to change { subject.facing }.from('north').to('east')
    end

    it 'should face south if from east' do
      subject.place(x: 0, y: 0, facing: 'east')
      expect { subject.right }.to change { subject.facing }.from('east').to('south')
    end

    it 'should face west if from south' do
      subject.place(x: 0, y: 0, facing: 'south')
      expect { subject.right }.to change { subject.facing }.from('south').to('west')
    end

    it 'should face north if from west' do
      subject.place(x: 0, y: 0, facing: 'west')
      expect { subject.right }.to change { subject.facing }.from('west').to('north')
    end
  end

  context 'move' do
    it 'should move y + 1 if facing north' do
      subject.place(x: 3, y: 3, facing: 'north')
      expect { subject.move }.to change { subject.y }.by(1)
    end

    it 'should move x + 1 if facing east' do
      subject.place(x: 3, y: 3, facing: 'east')
      expect { subject.move }.to change { subject.x }.by(1)
    end

    it 'should move y - 1 if facing south' do
      subject.place(x: 3, y: 3, facing: 'south')
      expect { subject.move }.to change { subject.y }.by(-1)
    end

    it 'should move x - 1 if facing west' do
      subject.place(x: 3, y: 3, facing: 'west')
      expect { subject.move }.to change { subject.x }.by(-1)
    end

    it 'should stay same position if out of bounds' do
      subject.place(x: 0, y: 0, facing: 'south')
      expect { subject.move }.not_to change { subject.y }
    end

    it 'should raise error if there is robot is not placed on table top' do
      expect { subject.move }.to raise_error { Robot::Error }
    end
  end

  context 'placed?' do
    it 'should return false if robot is not on valid tabletop coordinate and facing' do
      expect(subject.placed?).to be_falsy
    end

    it 'should return true if robot is on valid tabletop coordinate and facing' do
      subject.place(x: 0, y: 0, facing: 'north')
      expect(subject.placed?).to be_truthy
    end
  end
end