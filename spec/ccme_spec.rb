require 'spec_helper'

describe CC do
  it 'has a version number' do
    expect(CC::VERSION).not_to be nil
  end

  describe CCMe do
    subject { CCMe.new }
    it { is_expected.to be_a(Thor) }

    describe '#status' do
    end
  end
end
