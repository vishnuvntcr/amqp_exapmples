
#!/usr/bin/env ruby
# encoding: utf-8

require "bunny"

conn = Bunny.new(:automatically_recover => false)
conn.start
n = 1

ch   = conn.create_channel
ch.prefetch(n);
q = ch.queue("vishnu", :durable => true)
# x    = ch.fanout("logs")

msg  = ARGV.empty? ? "Hello World!" : ARGV.join(" ")

(-5..5).each do |i|
  q.publish(i.to_s, :persistent => true)
end

# ch.ack("message received")

puts " [x] Sent #{msg}"


conn.close
