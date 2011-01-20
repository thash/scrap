<?php

/* first, read XML files and get close data */
$file = fopen($argv[1], 'r');
if ($file) {
$hash = array();
    while (!feof($file)) {
        $line = fgets($file);

        $ary = preg_split("/[ ]+/", ereg_replace("\r|\n","",$line));
        $hash[$ary[0]] = $ary[1];

//var_dump($ary[0]);
//var_dump($ary[1]);

    }
}


/* second, load tick file and add close value */
$tickfile = fopen($argv[2], 'r');

if ($tickfile) {
    while (!feof($tickfile)) {

        $tickline = fgets($tickfile);
        $a = substr($tickline, 0, 7);
        $tickpair = ereg_replace("/","",$a);
        // print ($tickpair . "\n");

        /* if header or blank line, skip. */
        if (preg_match("/pair/", $tickline) || strcmp("\n", $tickline) == 0){
        //   print ($tickline);

        /* else, get value from Hash and attach to EOL */
        }else{

            $closeXML = ", XML$argv[3]=>, " . $hash[$tickpair];

            $tickline_add = ereg_replace("\r|\n","",$tickline) . $closeXML . "\n";

            /* final output */
            print_r ($tickline_add);
            //////////////////

}

    }
}

fclose($file);
fclose($tickfile);

//var_dump($hash);



// tick data csv (example)
//pair, timestamp, bid, ask, diff, close
//USD/JPY, 2011/01/12 00:00:00,  83.23, 83.27, 0.53, 82.7

/** contents of $hash (example)
* array(22) {
*   ["USDJPY"]=> *   string(5) "83.25"
*   ["EURJPY"]=> *  string(5) "108.0"
*   .....
*  ["NZDCHF"]=> *  string(4) "0.74"
*  [""]=> *  NULL
*}
*/
?>
