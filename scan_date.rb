require 'fileutils'
require 'kconv'
require 'date'
require 'pp'

origin_dir = "/Users/hash/work/file-sync/origin/"
Dir.chdir origin_dir
origin_files = Dir.glob "./**/*"

origin_files.each {|f|
    # get file base-name (remove extention)
    first_base = File.basename(f, ".*") 
    puts first_base

    # scan base-name and get date expression(s) > into Array
    date_in_name = first_base.scan(/\d{8}/)
    #TODO: add case name.txt.YYYYMMDD

    puts "----"
    pp date_in_name
    puts date_in_name[0].class

    if date_in_name != []

        # get last(-1st) date in filename
        date_start_index = first_base.to_s.rindex(date_in_name[-1]) 
        puts date_start_index

        # get from start point to last(-1)
        second_base = first_base[date_start_index .. -1] 
        puts second_base

        puts second_base.split("_")[1]
        
    else
        next
    end
    puts "-------------------"
    #elsif end in YYYYMMDD
    #else = there's no YYYYMMDD in file
}

