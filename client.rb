require 'socket'

host = 'localhost'
port = 2000

s=TCPSocket.open(host,port)

motd=s.gets
puts motd


loop {
  cmd = gets
  s.puts cmd
  response=s.gets
  puts response
}



  cmd=gets
  s.puts cmd
  puts 'Command sent'
  r=nil
  while r.nil? do
    r=s.gets
  end
  puts r
