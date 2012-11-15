# encoding: UTF-8

$LOAD_PATH << '.'

require 'vote-schulze'

puts "Hello everybody. I'm running"

vs = SchulzeBasic.do File.open("votes/vote4.list")
puts vs.ranks
puts vs.ranks_abc