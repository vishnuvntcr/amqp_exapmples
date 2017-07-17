#!/usr/bin/env ruby
# encoding: utf-8

require "bunny"

$conn = Bunny.new(:automatically_recover => false)
$conn.start
n = 1

$ch  = $conn.create_channel
$ch.prefetch(n);
$q = $ch.queue("vishnu", :durable => true)

puts " [*] Waiting for logs. To exit press CTRL+C"

begin
  $q.subscribe(:block => true, :manual_ack => true) do |delivery_info, properties, body|
    puts " [x] #{body}"
    sleep 1
    number = body.to_i
    begin
      0 / number if number < 1
      p "No errrors: positive ack"
      $ch.ack(delivery_info.delivery_tag)
    rescue Exception => e
      p "Error occured#{e.message} negative ack"
      $ch.nack(delivery_info.delivery_tag, false, true)
    end
    # p "delivery_info: #{delivery_info}"
    # p "delivery_infod elivery_tag: #{delivery_info.delivery_tag}"
    # p "delivery_info.routing_key : #{delivery_info.routing_key}"
    # p "properties: #{properties.inspect}"
  end
rescue Interrupt => _
  $ch.close
  $conn.close

  exit(0)
end
