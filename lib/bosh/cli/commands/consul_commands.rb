module Bosh::Cli::Command
  class ConsulCommands < Base
    include Bosh::Cli::Validation

    DEFAULT_CONFIG_PATH = File.expand_path('~/.bosh_consul_config')

    def initialize(runner)
      super(runner)
      # options[:config] ||= DEFAULT_CONFIG_PATH # hijack Cli::Config
    end

    usage "consul"
    desc  "show consul commands"
    def consul_help
      say("bosh consul commands:")
      nl
      cmds = Bosh::Cli::Config.commands.values.find_all {|c|
        c.usage =~ /consul/
      }
      Bosh::Cli::Command::Help.list_commands(cmds)
    end


    usage "target consul"
    desc  "target a consul cluster"
    def target_consul(deployment_name)
      require "bosh/consul"

      say "Fetching consul cluster info from deployment '#{deployment_name}'..."
      cluster = Bosh::Consul::Models::Cluster.new(director)
      cluster.load_from_deployment_name(deployment_name)
      step("Current consul cluster from deployment '#{deployment_name}'", "Cannot find consul cluster '#{deployment_name}'", :fatal) do
        cluster.valid?
      end
      show_cluster(cluster)

      consul_config = config.read("consul") || {}
      consul_config[target] = { "leader" => cluster.leader, "peers" => cluster.peers, "domain" => cluster.domain }
      config.write_global("consul", consul_config)
      config.save

    rescue Bosh::Cli::ValidationHalted
      err errors.first
    # rescue => e
    #   puts e.message
    end

    usage "consul status"
    desc "display status of target consul cluster"
    def display_status
      require "bosh/consul"

      verify_target_consul_config
      cluster = load_cluster
      show_cluster(cluster)
    end

    usage "consul services"
    desc "display services advertises on consul"
    def display_services
      require "bosh/consul"

      cluster = load_cluster
      domain = cluster.domain

      services = Bosh::Consul::Models::Services.new
      require "pp"
      items = services.load_from_ip(cluster.leader)

      previous_name = nil
      view = table(items) do |t|
        t.headings = ["name", "service id", "ip", "port", "tags", "dns"]
        items.each do |item|
          same_as_previous = (previous_name == item["ServiceName"])
          if previous_name && !same_as_previous
            t.add_separator
          end

          dns = ["#{item["ServiceName"]}.service.#{domain}"]

          t << [
            same_as_previous ? "" : item["ServiceName"],
            same_as_previous ? "" : item["ServiceID"],
            item["Address"],
            item["ServicePort"],
            (item["ServiceTags"] || []).join(", "),
            dns.join(", ")
          ]
          previous_name = item["ServiceName"]
        end
      end
      say(view)

    end

    private
    def show_cluster(cluster)
      say('Leader'.ljust(10) + cluster.leader)
      say('Peers'.ljust(10) + cluster.peers.join(", "))
    end

    # loads consul configuration for the target director
    def target_consul_config
      consul_config = config.read("consul") || {}
      consul_config[target]
    end

    def verify_target_consul_config
      unless target_consul_config
        err "First target a consul deployment with 'bosh target consul'"
      end
    end

    def load_cluster
      leader_ip = target_consul_config["leader"]
      cluster = Bosh::Consul::Models::Cluster.new(director)
      cluster.load_from_agent(leader_ip)
      cluster
    end
  end
end
