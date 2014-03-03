require 'socket'
require './command.rb'

#require './database.rb'
#init_db

#require './player.rb'

require 'logger'

require 'active_record'


# Require all models
Dir.glob('./app/models/*').each { |r| require r }


# Set up the database with ActiveRecord
require 'yaml'
dbconfig = YAML::load(File.open('./db/database.yml'))
ActiveRecord::Base.establish_connection(dbconfig)
#ActiveRecord::Base.logger = Logger.new(STDERR)
puts 'SQLite Database intilialized'
###

class QServer

  attr_accessor :defaultCmd, :current_user

  def initialize
    @s=TCPServer.open(2000)

    # This is dumb, but it stupidly responds for now with basic responses
    @cmds = []
    @cmds << Command.new(:name=>'walk', :response=>'You walk forward.')
    @cmds << Command.new(:name=>'look', :response=>'You see nothing but a small dog.')
    @cmds << Command.new(:name=>'pet', :response=>'You pet the dog. He bites your hand off. You lose.')
    @cmds << Command.new(:name=>'run', :response=>'You run away, out of breath, a dragon appears.')
    @cmds << Command.new(:name=>'slay', :response=>'You hit the dragon with a stick, he responds by eating you whole.')
    @cmds << Command.new(:name=>'say', :needs_arg=>true)
    @cmds << Command.new(:name=>'nick', :needs_arg=>true)

    @defaultCmd=Command.new(:name=>'', :response=>'Nothing happened.')

    @current_user = nil

    puts 'Server starting on port 2000...'
    start

  end

  # Find the appropriate command object for whatever clin is
  # I'm so sorry
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

  def motd client
      client.puts "Hello #{@current_user.name}. To change your name type 'nick NewName'"    
  end

  def start
    puts 'Server started.'
    loop {
      puts 'loop'
      Thread.start(@s.accept) do |client|
      begin
        puts 'A new user has connected.'
        @current_user = Player.create
        # Send up the motd, the first response upon login
        motd client
        loop {
          clin_raw = client.gets
          if !clin_raw.nil?
            clin = clin_raw.chomp
            puts "  - Client says: #{clin}"
            result = process_command clin
            puts '  - Send response: '+result
            client.puts result
          end
        }
      rescue Exception => e
        client.puts e
        p e
        print e.backtrace.join("\n")
      end
      end
    }
  end

end
