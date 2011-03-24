require 'base64'

if ARGV.length < 2
	puts "need 2 args"
	exit
end

if ARGV[0] == "-e"

file = File.open(ARGV[1])
base64_text = [file.read].pack('m')
puts base64_text
#puts Base64.encode64("hoge")

elsif ARGV[0] == "-d"

# #File.open("fuga.xlsx", "wb") do |f|
#File.open(ARGV[1], "wb") do |f|
#  #Base64 -> binary
#    f.write(base64_text.unpack('m')[0])
#    end
#
	
	else
		puts "option: -e = Encode, -d = Decode"
		exit
end
