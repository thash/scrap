require 'fileutils'
require 'kconv'
require 'date'
require 'pp'

origin_dir = "/Users/hash/work/file-sync/origin/"
Dir.chdir origin_dir
origin_files = Dir.glob "./**/*"

date_type = %w( AFTER_DOT BEFORE_DOT)
date_in_name = []

origin_files.each {|f|

    #check extension
    ext = File.extname(f) 
    puts "check extension ...  #{ext}"

    if ext =~ /\.\d{8}/
        puts date_type[0]
        date_in_name << ext.scan(/\d{8}/)
    end

    #check base-name (remove extention)
    first_base = File.basename(f, ".*") 
    puts first_base

    # scan base-name and get date expression(s) > into Array
    if first_base.scan(/\d{8}/) != []
        puts date_type[1]
        date_in_name << first_base.scan(/\d{8}/)
        pp date_in_name

        # get last(-1st) date in filename
        date_start_index = first_base.to_s.rindex(date_in_name[-1]) 
        puts date_start_index
        # get from start point to last(-1)
        second_base = first_base[date_start_index .. -1] 
        puts second_base
        puts second_base.split("_")[1]
    end

    puts "date in one file \"" + f + "\" : " + date_in_name.join(",")

    #elsif YYYYMMDD
    #else = there's no YYYYMMDD in file
    puts "-------------------"
}

