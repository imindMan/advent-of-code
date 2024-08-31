<?php
    $myfile = fopen("day11.txt", "r") or die("Unable to open file!");
    // Output one line until end-of-file
    $data = [];
    while(!feof($myfile)) {
        $data[] = substr_replace(fgets($myfile), '', -1);
    }
    fclose($myfile);
    array_pop($data);
    var_dump($data);

    function extendUniverse($universe) {
        for ($x = 0; $x < count($universe); $x++) {
            if (strpos($universe[$x], '#') == false) {
                array_splice($universe, $x, 0, str_repeat('.', count($universe[$x])));
            }
        }
    }

    extendUniverse($data);

    var_dump($data);
?>
