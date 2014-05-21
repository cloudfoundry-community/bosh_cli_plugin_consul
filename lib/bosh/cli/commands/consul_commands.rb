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
      say "Fetching consul cluster info for deployment '#{deployment_name}'..."
      cluster = Bosh::Consul::Models::Cluster.new(director)
      cluster.load_from_deployment_name(deployment_name)
      step("Current consul cluster '#{deployment_name}'", "Cannot find consul cluster '#{deployment_name}'", :fatal) do
        cluster.valid?
      end
      p cluster.consul_ips
      
    rescue Bosh::Cli::ValidationHalted
      err errors.first
    end

    usage "consul status"
    desc "display status of target consul cluster"
    def display_status

    end

    usage "consul services"
    desc "display services advertises on consul"
    def display_services

    end
  end
end
