#!/usr/bin/ruby
# TODO: youtube download

require 'rubygems'
require 'mechanize'
require 'kconv'
require 'cgi'
require 'json'                                                                                                                                                                 
downlist = [
#All Done
]

# to conceal my mailaddress and pw from public
if File.exist?('./propaties_nico.json')
    propaties_file = File.open("propaties_nico.json")
    json_hash = JSON.parse(propaties_file.read)

    mail = json_hash["mail"]
    password = json_hash["password"]
else 
    puts "please put [propaties_nico.json] file in your dir"
    exit
end
 
agent = WWW::Mechanize.new
agent.post('https://secure.nicovideo.jp/secure/login?site=niconico',
'mail' => mail,'password' => password)
 

#ranking_page = agent.get('http://www.nicovideo.jp/ranking/mylist/daily/all')
#video_link = (ranking_page.parser/"a.video").first
#video_id = video_link["href"].scan(/sm\d+$/).first
#agent.get(video_link["href"])

downlist.each{|url|
video_link = url
video_id = video_link.scan(/sm\d+$/).first 
#video_id = video_link.scan(/nm\d+$/).first

agent.get(video_link)
 
puts video_id
 
#...URL...
content = agent.get('http://www.nicovideo.jp/api/getflv?v=' + video_id)
hash = Hash.new
content.body.scan(/([^&]+)=([^&]*)/).each {|v| hash[v[0]] = v[1]}
video_url = CGI.unescape(hash['url'])
 
#
open(video_id+'.flv','wb'){|f| f.print agent.get_file(video_url)}
}
