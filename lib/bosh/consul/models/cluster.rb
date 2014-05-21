require "rest_client"

class Bosh::Consul::Models::Cluster
  attr_reader :director_client
  attr_reader :leader, :peers

  def initialize(director_client)
    @director_client = director_client
  end

  # A [re-]initialization method to get IPs for a cluster
  def load_from_deployment_name(deployment_name)
    @leader = nil
    # fetch_vm_state raises error if name invalid
    vms = director_client.fetch_vm_state(deployment_name)
    deployment_ips = vms.map {|vm| vm["ips"].first }
    discover_from_ips(deployment_ips)
  end

  # Discover the consul cluster from the IPs of servers or clients to the cluster
  def discover_from_ips(ips)
    ip = ips.first
    api = consul_api(ip)
    if @leader = api["/v1/status/leader"].get
      @leader =~ /"(.*)"/
      @leader = $1
      @peers = JSON.parse(api["/v1/status/peers"].get)
    end
  end

  def valid?
    @leader
  end

  private
  def consul_api(ip)
    RestClient::Resource.new("http://#{ip}:8500")
  end
end
