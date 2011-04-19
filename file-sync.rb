require 'fileutils'
require 'kconv'

#sample: http://d.hatena.ne.jp/takuya_1st/20100921/1285054620
#TODO: this script refer only file name (don't check data itself, so it cannot track rename).

origin_dir = "/Users/hash/work/file-sync/origin/"
target_dir = "/Users/hash/work/file-sync/target/"

puts "create file list"

Dir.chdir origin_dir
origin_files = Dir.glob "./**/*"
Dir.chdir target_dir
target_files = Dir.glob "./**/*"

puts "origin_files"
puts origin_files
puts ""

puts "target_files"
puts target_files
puts ""

puts "::::::::::::::::::::IDENTICAL FILES::::::::::::::::::::"
if (target_files & origin_files) != []
    puts "target_files & origin_files"
    puts (target_files & origin_files)
    puts ""

    (target_files & origin_files).reject{|same_name_file|
        FileUtils.cmp( File.expand_path(same_name_file,origin_dir) , File.expand_path(same_name_file,target_dir) )}.select{|same_name_file|
            if (File.mtime(File.expand_path(same_name_file,origin_dir)) > File.mtime( File.expand_path(same_name_file,target_dir)))
                puts "XXXXXXXXXXXXXXXXXXXXorigin is newer than target => name:" + same_name_file
                FileUtils.copy( File.expand_path(same_name_file,origin_dir) , File.expand_path(same_name_file,target_dir) )
                #TODO: cannot over write yet.

            elsif (File.mtime(File.expand_path(same_name_file,origin_dir)) < File.mtime( File.expand_path(same_name_file,target_dir)))
                puts "target is newer than origin => name:" + same_name_file
            else
                # TODO why cannot come here?
                puts "timestamp of files are same"
            end
        }
        puts ""

else
    puts "no identical file"
end


puts "::::::::::::::::::::DIFFERENCE::::::::::::::::::::"
if (origin_files - target_files) != []
    puts "[oritin O vs X target] should copy origin to target"
    puts (origin_files - target_files)
    puts ""

    (origin_files - target_files).each{|one_side_file|
        FileUtils.copy( File.expand_path(one_side_file,origin_dir) , File.expand_path(one_side_file,target_dir) )
    }
elsif (target_files - origin_files) != []

    puts "# desabled now: [oritin X vs O target] should copy target to origin"
    puts "# "+(target_files - origin_files).to_s
    puts ""

else 
    puts "no difference in file lists"
end

