#!/usr/bin/ruby

def calcRealDiff(day, outputfilename)
    # proccess of each file
    filename = "tickCSV#{day.to_s}.csv-#{(day-2).to_s}-#{(day-1).to_s}"
    #filename = "test.csv"
    if File.exist?(filename)
        file = File.open(filename,"r+")
        output = File.open(outputfilename, "w"){|output|
            while line = file.gets

                lineAry = line.split(",")
                #["AUD/JPY", " 2011/01/13 00:02:02",
                #    "  82.59", " 82.65", " 0.45", " 82.14",
                #    " XML11=>", " 82.15",
                #    " XML12=>", " 82.7"]

                pair = lineAry[0].strip
                timestamp = lineAry[1].strip
                bid = lineAry[2].strip.to_f
                ask = lineAry[3].strip.to_f
                diff = lineAry[4].strip.to_f
                close = lineAry[5].strip.to_f
                nameXML1  = lineAry[6].strip
                closeXML1 = lineAry[7].strip.to_f
                nameXML2  = lineAry[8].strip
                closeXML2 = lineAry[9].strip.to_f

                if (pair != nil || timestamp != nil || bid != nil || ask != nil || diff != nil || close != nil || nameXML1  != nil || closeXML1 != nil || nameXML2  != nil || closeXML2 != nil)

                    timestamp.split(/[: ]/)[1].to_i < 6 ? \
                        used_closeXML = closeXML1 : used_closeXML = closeXML2


                    output.puts(line.sub("\n","") + ", " + \
                                sprintf("%3.4f",(bid - used_closeXML)) + ", " + \
                                # => diff in trade page
                                sprintf("%3.4f",(diff - (bid - used_closeXML))) + ", " + \
                                # => diff of diff
                                sprintf("%3.4f",(diff - (bid - used_closeXML)) - (used_closeXML - close))
                               )
                               # => real (strange round ignored) diff

                else
                end
            end unless file.gets == nil # read line
        }
    else #file not exist
    end
end

@dayAry = [13, 14, 15]
@dayAry.each do |day|
    day = day.to_i
    puts day.to_s + " is calculated..."
    calcRealDiff(day, "tickCSV#{day}.csv-#{day-2}-#{day-1}.real2")
    puts day.to_s + " is finished"
end
