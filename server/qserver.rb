require 'socket'
require './command.rb'
require './database.rb'

require 'logger'

logger = Logger.new(STDOUT)
logger.level = Logger::WARN


init_db


class Player < ActiveRecord::Base
  attr_accessor :name, :password, :level, :client
  def initialize __client
    name = 'Stranger'
    password = ''
    level = 1
    client = __client
  end
end

puts Player.count.to_s+'s players total'

class QServer

  attr_accessor :defaultCmd, :current_user

  def initialize
    @s=TCPServer.open(2000)

    @cmds = []
    @cmds << Command.new(:name=>'walk', :response=>'You walk forward.')
    @cmds << Command.new(:name=>'look', :response=>'You see nothing but a small dog.')
    @cmds << Command.new(:name=>'pet', :response=>'You pet the dog. He bites your hand off. You lose.')
    @cmds << Command.new(:name=>'nick', :needs_arg=>true)

    @defaultCmd=Command.new(:name=>'', :response=>'Nothing happened.')

    @current_user = nil

    puts 'Server starting on port 2000...'
    start

  end

  # Find the appropriate command object for whatever clin is
  def process_command(user_input)
    clin = user_input.split[0]
    arg = nil
    if user_input.split.length>1
      arg = user_input.split[1]
    end
    cmd = nil
    @cmds.each do |c|
      if c.name==clin
        cmd=c
      end
    end
    if cmd.nil?
      puts 'Default command used'
      cmd = @defaultCmd
    end
    puts "arg: #{arg}"
    cmd.result(arg,@current_user)
  end


  def start
    puts 'Server started.'
    loop {
      Thread.start(@s.accept) do |client|
      begin
        puts 'A new user has connected.'
        @current_user = Player.new(client)
        client.puts "Hello #{@current_user.name}. To change your name type 'nick NewName'"
        loop {
          clin_raw = client.gets
          if !clin_raw.nil?
            clin = clin_raw.chomp
            puts "  - Client says: #{clin}"
            result = process_command clin
            puts '  - Send response: '+result
            client.puts result
            puts '  - Sent!'
          end
        }
      rescue Exception => e
        p e
        print e.backtrace.join("\n")
      end
      end
    }
  end

end
