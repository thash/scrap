# -*- coding: utf-8 -*-

require 'pp'
r = [ "Hash","user2" ]

rid = r.map{|u| res = User.where(:name => u ).first; res._id if res }.compact

puts "------R-----"
pp rh = Hash[*rid.zip(r).flatten]

#puts "names => " + r.size.to_s
#puts "ids   => " + rh.size.to_s

