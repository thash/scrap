#! ruby -Ks
#require 'kconv'

check_dir = "C:\\Users\\t\.hashimoto\\git\\TODO"
script_file = Dir::pwd + "/" + __FILE__

puts "work in:  " + script_file
puts
while true
	status = ""
	Dir.chdir(check_dir){
		#system("pwd")
		system("rm tmp") if File.exists?("tmp")
		system("git status > tmp")
		
		### check status
		if File.exists?("tmp")
			tmp = File.open("tmp") 
			#puts status + "11111"
			while line = tmp.gets
				if line =~ /nothing to commit \(working directory clean\)/
					status = "nothing"
				elsif line =~ /# Untracked files:/
					status = "newfile"
				elsif line =~ /# Changes not staged for commit:/
					status = "changed"
					#if some files are deleted ... 
					#no need for todo.
					#status = "deletefile";puts "deletefile"
					#system("git rm #{deletedfilename}")
					#... should be array (many files may be deleted)
				end
				#puts status + "22222"
			end
			tmp.close
			system("rm tmp")
		end

		if status != "nothing"
			system("git add . > null")
			system("git commit -m \"auto commit by #{script_file}\" > null")
		end
	}
	sleep 5 * 60
end
