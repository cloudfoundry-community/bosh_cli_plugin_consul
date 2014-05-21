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

end
