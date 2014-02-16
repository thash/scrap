#!/usr/bin/osascript

on run argv
    repeat with arg in argv
        try
            open for access arg
            set note_text to read arg as «class utf8»
        end try
        close access arg
        set filename to arg as string
        set notetitle to my build_title(filename)
        log notetitle
        tell application "Evernote"
            create note title notetitle with text note_text notebook {"IRC"}
        end tell
    end repeat
end run

on build_title(filename)
    set date_log to my trim_line(filename, FILEPREFIX, 0)
    set mydate to my trim_line(date_log, ".log", 1)
    return NOTEPREFIX & mydate
end build_title

-- http://www.macosxautomation.com/applescript/sbrt/sbrt-06.html
on trim_line(this_text, trim_chars, trim_indicator)
	-- 0 = beginning, 1 = end, 2 = both
	set x to the length of the trim_chars
	-- TRIM BEGINNING
	if the trim_indicator is in {0, 2} then
		repeat while this_text begins with the trim_chars
			try
				set this_text to characters (x + 1) thru -1 of this_text as string
			on error
				-- the text contains nothing but the trim characters
				return ""
			end try
		end repeat
	end if
	-- TRIM ENDING
	if the trim_indicator is in {1, 2} then
		repeat while this_text ends with the trim_chars
			try
				set this_text to characters 1 thru -(x + 1) of this_text as string
			on error
				-- the text contains nothing but the trim characters
				return ""
			end try
		end repeat
	end if
	return this_text
end trim_line
