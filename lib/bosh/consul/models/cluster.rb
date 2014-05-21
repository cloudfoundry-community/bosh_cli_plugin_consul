class Bosh::Consul::Models::Cluster
  attr_reader :director_client
  attr_reader :consul_ips

  def initialize(director_client)
    @director_client = director_client
  end

  def load_from_deployment_name(deployment_name)
    @consul_ips = nil
    if vms = director_client.fetch_vm_state(deployment_name)
      @consul_ips = vms.map {|vm| vm["ips"].first }
    end
  end

  def valid?
    !consul_ips.empty?
  end
end
