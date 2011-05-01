"TODO: call this script when every file is saved

for line in readfile("a.txt")
    "TODO: readfile name should not be fixed, should be currently editing file
    if line != ''
        echo "not blank"
        exit
    endif
    echo line
    echo "file is blank. delete?"
    "TODO: show y/n question when file is blank
    "TODO: delete file when select y
endfor
