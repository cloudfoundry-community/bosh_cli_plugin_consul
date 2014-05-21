describe Bosh::Consul::Models::Cluster do
  let(:director) { double("Bosh::Cli::Client::Director") }

  subject { Bosh::Consul::Models::Cluster.new(director) }

  it "initially does not represent a cluster" do
    expect(subject.valid?).to be_false
  end

  it "can load consul cluster IPs from any deployment" do
    expect(director).to receive(:fetch_vm_state).and_return([{"ips" => ["10.244.4.2"]}, {"ips" => ["10.244.4.6"]}])
    expect(subject).to receive(:discover_from_ips).with(["10.244.4.2", "10.244.4.6"])
    subject.load_from_deployment_name("foobar")
  end

  it "can load cluster from single IP of consul server or agent" do
    expect(subject).to receive(:discover_from_ips).with(["10.244.4.2"])
    subject.load_from_agent("10.244.4.2")
  end

  context "from any agent" do
    let(:target_ip) { "10.244.10.10" }
    let(:api) { RestClient::Resource.new("http://#{target_ip}:8500") }

    it "can discover the leader & peers" do
      expect(subject).to receive(:get).with("10.244.10.10", "/v1/status/leader").and_return('"10.244.4.2:8300"\n')
      expect(subject).to receive(:get).with("10.244.10.10", "/v1/status/peers").and_return('["10.244.4.2:8300", "10.244.4.6:8300"]')
      subject.discover_from_ips(["10.244.10.10"])
      expect(subject.leader).to eq "10.244.4.2"
      expect(subject.peers).to eq ["10.244.4.2", "10.244.4.6"]
    end
  end

end
