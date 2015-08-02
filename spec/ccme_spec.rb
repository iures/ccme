require 'spec_helper'

describe CC do
  it 'has a version number' do
    expect(CC::VERSION).not_to be nil
  end

  describe CCMe do
    subject { CCMe.new }
    it { is_expected.to be_a(Thor) }

    describe '#watch' do
      it 'keeps quering for status until it changes from pending' do
        allow(subject).to receive(:status).and_return('pending', 'pending', 'success')
        allow(subject).to receive(:api_hits_every) { 0.1 }
        expect(subject).to receive(:status).exactly(3).times.and_return('pending', 'pending', 'success')
        subject.watch
      end
    end
  end
end
