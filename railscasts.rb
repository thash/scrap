# -*- coding: utf-8 -*-
require 'rubygems'
require 'mechanize'
# require 'pry'

@save_dir = "~/Dropbox/Movie/"
runtag = ARGV.shift.to_i

a = Mechanize.new {|agent| agent.user_agent_alias = "Mac Safari" }
a.get("http://railscasts.com/?tag_id=#{runtag}") {|page|
  @total_page = if page.at(".next_page") == nil
                  1
                else
                  page.at(".next_page").previous_element.text.to_i
                end
}

for i in 1..@total_page do
  a.get("http://railscasts.com/?page=#{i}&tag_id=#{runtag}") do |page|
    page.links.each do |link|
      if (path = link.attributes.attributes["href"].value) =~ /(episodes).*?autoplay=true$/
        puts path
        a.get("http://railscasts.com"+path) do |mvpage|
          mvpage.links.each do |mvlink|
            if (mp4 = mvlink.attributes.attributes["href"].value) =~ /\.mp4$/
              puts filename =  runtag.to_s + "_" + mp4.split("/")[-1]
              `wget #{mp4} -o mv.log -O #{@save_dir}#{filename}`
            end
          end
        end
      end
    end
  end
end
