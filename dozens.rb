# -*- coding: utf-8 -*-

### Gemfile >>>
# source :rubygems
# gem 'json'
### <<< Gemfile

require 'rubygems'
require 'bundler/setup'
Bundler.require

@secret = YAML.load_file('./secret.yml')

USER   = @secret["user"]
KEY    = @secret["api_key"]

DOMAIN = @secret["domain"]
FQDN   = @secret["fqdn"]
TYPE   = "A"

puts "========================="
puts Time.now.to_s

token  = `curl -s http://dozens.jp/api/authorize.json -H X-Auth-User:#{USER} -H X-Auth-Key:#{KEY} | sed 's/.*:"//' | sed 's/"}//'`.chomp
res    = `curl -s http://dozens.jp/api/record/#{DOMAIN}.json -H X-Auth-Token:#{token}`
json   = JSON.parse(res)
target = json["record"].select{|r| r["name"] == FQDN && r["type"] == TYPE }.first
exit if target == nil

gip    = `curl -s ifconfig.me/ip`.chomp
print "target: "; puts target

#    resp = `curl -X POST -d #{data} #{header} -s http://dozens.jp/api/record/update/33375.json`
resp = `curl -d '{"prio":"","content":"#{gip}","ttl":"7200"}' -H "X-Auth-Token:#{token}" -H "Host: dozens.jp" -H "Content-Type:application/json" -s http://dozens.jp/api/record/update/#{target["id"]}.json`

print "response: "; puts resp
print "check: "; puts `curl -s http://dozens.jp/api/record/#{DOMAIN}.json -H X-Auth-Token:#{token}`

