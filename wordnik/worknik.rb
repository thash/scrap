# encoding: utf-8
require 'rubygems'
require 'bundler/setup'
Bundler.require

Wordnik.configure do |c|
  c.api_key = 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx' # lookup EN
end

p Wordnik.word.get_definitions('distinguish').map{|res| res["text"]}

p Wordnik.word.get_definitions('perceive').map{|res| res["text"]}
