require 'win32ole'

module WORD_CONST
end

def usage
print "usage: ruby this_script.rb files.. \n"
end

if ARGV.size < 1
usage
exit(1)
end

wd = WIN32OLE.new("Word.Application.9") # 9 is version (word2000)
WIN32OLE.const_load wd, WORD_CONST
ex = WIN32OLE.new("Excel.Application.9")
ex.visible = true
book = ex.workbooks.add
sheet = book.worksheets(1)
cells = sheet.cells
cols = [
    ["filename", 14, 0],
    ["date", 16, WORD_CONST::WdPropertyTimeLastSaved],
    ["date", 10, WORD_CONST::WdPropertyLastAuthor],
    ["date", 32, WORD_CONST::WdPropertyTitle],
    ["date", 24, WORD_CONST::WdPropertySubject],
    ["date",  8, WORD_CONST::WdPropertyBytes],
]

i = 1
cols.each do |x|
cells.item(1,i).value = x[0]
cells.item(1,i).colWidth = x[1]
i += 1
end

for doc in ARGV
wdoc = wd.Documents.open doc, false, true
print "file: " + doc + "\n"
ps = wdoc.BuiltinDocumentProperties
cells.item(i,1).value = doc
j = 2
cols[1, cols.length - 1].each do |x|
cells.item(i,j).value = ps.item(x[2])
j += 1
end
wdoc.close WORD_CONST::WdDoNotSaveChanges
i += 1
end
sheet.range("B2:B" + i.to_s).numberFormatLocal
"yyyy/m/d h:m"
wd.quit


