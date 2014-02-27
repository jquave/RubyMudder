require 'socket'

host = 'localhost'
port = 2000

s=TCPSocket.open(host,port)

# Show the MOTD from the server
motd=s.gets
puts motd

# Just keep looping, sending and recieving messages unless that message is quit or exit
loop {
  cmd = gets
  s.puts cmd
  response=s.gets
  puts response
  if(cmd.chomp=='quit' || cmd.chomp=='exit')
    break
  end
}

