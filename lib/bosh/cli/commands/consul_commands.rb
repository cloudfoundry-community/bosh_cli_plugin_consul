module Bosh::Cli::Command
  class ConsulCommands < Base

    usage "consul"
    desc  "show consul commands"
    def cf_help
      say("bosh consul commands:")
      nl
      cmds = Bosh::Cli::Config.commands.values.find_all {|c|
        c.usage =~ /consul/
      }
      Bosh::Cli::Command::Help.list_commands(cmds)
    end


    usage "target consul"
    desc  "target a consul cluster"
    def target(name_or_hosts)
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
