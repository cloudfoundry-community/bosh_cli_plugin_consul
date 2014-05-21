BOSH CLI plugin for Consul
==========================

If you're using consul within your BOSH deployments (such as [redis-boshrelease](https://github.com/cloudfoundry-community/redis-boshrelease#consul-service-advertisement)), or running a cluster of consul servers ([consul-boshrelease](https://github.com/cloudfoundry-community/consul-boshrelease)), this BOSH CLI plugin is a very handy ops tool.

Installation
------------

Install via RubyGems:

```
$ gem install bosh_cli_plugin_consul
```

Usage
-----

To see the list of commands: `bosh consul`

To use the CLI plugin, first target the consul cluster (`bosh target consul`).

### Target consul

The CLI can discover the consul cluster from any BOSH deployment using consul. The consul cluster does not even have to be managed by BOSH.

```
$ bosh target consul
1. consul-warden
2. redis-warden
Choose a deployment: 2
Fetching consul cluster info from deployment 'redis-warden'...

Current consul cluster from deployment 'redis-warden'        OK
Leader    10.244.4.6
Peers     10.244.4.14, 10.244.4.6, 10.244.4.10
```

### View services

```
$ bosh consul services
+--------------+--------------+-------------+------+--------+
| name         | service id   | ip          | port | tags   |
+--------------+--------------+-------------+------+--------+
| consul       | consul       | 10.244.4.6  | 8300 |        |
|              |              | 10.244.4.10 | 8300 |        |
|              |              | 10.244.4.14 | 8300 |        |
+--------------+--------------+-------------+------+--------+
| redis-warden | redis-warden | 10.244.2.6  | 6379 | master |
|              |              | 10.244.2.14 | 6379 | slave  |
|              |              | 10.244.2.10 | 6379 | slave  |
+--------------+--------------+-------------+------+--------+

$ bosh consul services --dns
+--------------+--------------+-------------+------+--------+-----------------------------------------------------------------+
| name         | service id   | ip          | port | tags   | dns                                                             |
+--------------+--------------+-------------+------+--------+-----------------------------------------------------------------+
| consul       | consul       | 10.244.4.6  | 8300 |        | consul.service.consul                                           |
|              |              | 10.244.4.10 | 8300 |        | consul.service.consul                                           |
|              |              | 10.244.4.14 | 8300 |        | consul.service.consul                                           |
+--------------+--------------+-------------+------+--------+-----------------------------------------------------------------+
| redis-warden | redis-warden | 10.244.2.6  | 6379 | master | redis-warden.service.consul, master.redis-warden.service.consul |
|              |              | 10.244.2.14 | 6379 | slave  | redis-warden.service.consul, slave.redis-warden.service.consul  |
|              |              | 10.244.2.10 | 6379 | slave  | redis-warden.service.consul, slave.redis-warden.service.consul  |
+--------------+--------------+-------------+------+--------+-----------------------------------------------------------------+
```

Contributing
------------

1. Fork it ( https://github.com/[my-github-username]/bosh_cli_plugin_consul/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
