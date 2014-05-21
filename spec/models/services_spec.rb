describe Bosh::Consul::Models::Services do
  subject { Bosh::Consul::Models::Services.new }

  it "fetches services" do
    expect(subject).to receive(:get).with("10.244.4.2", "/v1/catalog/services").and_return('{"consul":[],"redis-warden":["master", "slave"]}')
    expect(subject).to receive(:get).with("10.244.4.2", "/v1/catalog/service/consul").and_return('[{"Node":"consul-warden-consul_server_z1-0","Address":"10.244.4.6","ServiceID":"consul","ServiceName":"consul","ServiceTags":null,"ServicePort":8300},{"Node":"consul-warden-consul_server_z1-1","Address":"10.244.4.10","ServiceID":"consul","ServiceName":"consul","ServiceTags":null,"ServicePort":8300},{"Node":"consul-warden-consul_server_z1-2","Address":"10.244.4.14","ServiceID":"consul","ServiceName":"consul","ServiceTags":null,"ServicePort":8300}]')
    expect(subject).to receive(:get).with("10.244.4.2", "/v1/catalog/service/redis-warden").and_return('[{"Node":"redis-warden-redis_leader_z1-0","Address":"10.244.2.6","ServiceID":"redis-warden","ServiceName":"redis-warden","ServiceTags":["master"],"ServicePort":6379},{"Node":"redis-warden-redis_z1-1","Address":"10.244.2.14","ServiceID":"redis-warden","ServiceName":"redis-warden","ServiceTags":["slave"],"ServicePort":6379},{"Node":"redis-warden-redis_z1-0","Address":"10.244.2.10","ServiceID":"redis-warden","ServiceName":"redis-warden","ServiceTags":["slave"],"ServicePort":6379}]')

    subject.load_from_ip("10.244.4.2")
  end
end
