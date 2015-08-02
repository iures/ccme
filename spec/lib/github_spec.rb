require 'spec_helper'

describe Github do
  subject { Github.new 'TOKEN'}
  describe "#status" do
    let(:status) { double(:status, :first => 'success') }
    let(:head) { double(:head, :oid => "25d6db8a34ce094a2ca0d84fd9996102009e16c7") }
    let(:github_client) { double(:github_client, :statuses => status) }

    it "returns the last circle status" do
      allow(subject).to receive(:github_client).and_return(github_client)
      allow(subject).to receive(:github_repo).and_return("iures/ccme")
      allow(subject).to receive(:head).and_return(head)
      expect(github_client).to receive(:statuses).with("iures/ccme", head.oid)
      expect(subject.status).to eq('success')
    end
  end
end
