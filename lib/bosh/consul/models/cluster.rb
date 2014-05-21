class Bosh::Consul::Models::Cluster
  attr_reader :director_client
  attr_reader :leader, :peers, :domain

  def initialize(director_client)
    @director_client = director_client

    # FIXME: waiting on an API endpoint to discover the domain
    @domain = "consul"
  end

  # A [re-]initialization method to get IPs for a cluster
  def load_from_deployment_name(deployment_name)
    @leader = @peers = nil

    # fetch_vm_state raises error if name invalid
    vms = director_client.fetch_vm_state(deployment_name)
    deployment_ips = vms.map {|vm| vm["ips"].first }
    discover_from_ips(deployment_ips)
  end

  def load_from_agent(leader_ip)
    @leader = @peers = nil
    discover_from_ips([leader_ip])
  end

  # Discover the consul cluster from the IPs of servers or clients to the cluster
  # Setups up @leader & @peers IP addresses
  def discover_from_ips(ips)
    ip = ips.first
    if @leader = get(ip, "/v1/status/leader")
      @leader =~ /"(.*):(\d+)"/
      @leader, @cluster_port = $1, $2
      @peers = JSON.parse(get(ip, "/v1/status/peers"))
      @peers.map! do |peer|
        peer =~ /(.*):(\d+)/
        $1
      end
    end
  end

  def valid?
    @leader
  end

  private
  def get(ip, path)
    consul_api(ip)[path].get
  end

  def consul_api(ip)
    RestClient::Resource.new("http://#{ip}:8500")
  end
end
