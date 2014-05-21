describe Bosh::Consul::Models::Cluster do
  it "initially does not represent a cluster" do
    expect(Bosh::Consul::Models::Cluster.new.valid?).to eq(false)
  end
end
