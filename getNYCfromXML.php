<?php

$file = fopen($argv[1], 'r');
if ($file) {
    $lastLine = "";
    while (!feof($file)) {
        $line = fgets($file);

        if (preg_match("/<NYC>/", $line)) {
            $nyc = strip_tags($line);
            $name_pre = strip_tags($lastLine);
            $name = ereg_replace("\r|\n","",$name_pre);
            print ($name . $nyc);
        }
        $lastLine = $line;
    }
}
fclose($file);

?>
