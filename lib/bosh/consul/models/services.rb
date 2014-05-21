class Bosh::Consul::Models::Services
  def load_from_ip(ip)
    nodes = []
    services = JSON.parse(get(ip, "/v1/catalog/services"))
    services.each do |name, tags|
      service_nodes = JSON.parse(get(ip, "/v1/catalog/service/#{name}"))
      nodes.push(*service_nodes)
    end
    nodes
  end

  private
  def get(ip, path)
    consul_api(ip)[path].get
  end

  def consul_api(ip)
    RestClient::Resource.new("http://#{ip}:8500")
  end
end
