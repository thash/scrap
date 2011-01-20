<?php

$file = fopen($argv[1], 'r');
if ($file) {
print("pair, timestamp, bid, ask, diff, close\n");
    while (!feof($file)) {
        $line = fgets($file);

       //if ($position = strpos ($line, 'close:')) {
       //     $cut = substr($line, $position + 6, 9);
       //     $close = ereg_replace("\r|\n","",$cut);
       //    print ($close . "\n");
       // }

if (stristr($line, "basic authentication")){
print "\n"; // skip line
} else {

        $position = strpos ($line, 'pair:');
        $line2 = substr($line, $position+5);
        $line3 = ereg_replace(",[^:]+:", ", ", $line2);
        print ($line3);
}
    }
}
fclose($file);

//function get specific value

//2011-01-12 00:00:00 INFO basic authentication scheme selected
//2011-01-12 00:00:00 INFO pair:USD/JPY, timestamp:2011/01/12 00:00:00, bid: 83.23, ask:83.27, diff:0.53, close:82.7
//2011-01-12 00:00:00 INFO pair:EUR/JPY, timestamp:2011/01/12 00:00:00, bid: 107.49, ask:107.56, diff:0.40, close:107.09
//2011-01-12 00:00:00 INFO pair:GBP/JPY, timestamp:2011/01/11 23:59:59, bid: 129.42, ask:129.52, diff:0.66, close:128.76
//2011-01-12 00:00:00 INFO pair:AUD/JPY, timestamp:2011/01/11 23:59:59, bid: 81.92, ask:82.0, diff:-0.40, close:82.32

//=> AUD/JPY, 2011/01/11 23:59:59, 81.92, 82.0, -0.40, 82.32
?>
