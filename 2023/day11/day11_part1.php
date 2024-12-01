<?php
    $myfile = fopen("day11.txt", "r") or die("Unable to open file!");
    // Output one line until end-of-file
    $data = [];
    while(!feof($myfile)) {
        $data[] = substr_replace(fgets($myfile), '', -1);
    }
    fclose($myfile);
    array_pop($data);

    function extendUniverse(&$universe) {
        // row addition
        for ($x = 0; $x < count($universe); $x++) {
            if (strpos($universe[$x], '#') === false) {
                array_splice($universe, $x, 0, str_repeat('.', strlen($universe[$x])));
                $x++;
            }
        }
        # column addition
        for ($y = 0; $y < strlen($universe[0]); $y++) {
            $col_check = "";

            foreach ($universe as $row) {
                $col_check .= $row[$y];
            }
            if (strpos($col_check, '#') === false) {
                for ($x = 0; $x < count($universe); $x++) {
                    $universe[$x] = substr($universe[$x], 0, $y) . '.' . substr($universe[$x], $y);
                }
                $y++;
            }
        } 
    }
    extendUniverse($data);
    function stepCounter($universe) {
        $x1 = 0;
        $y1 = 0;
        $counter = 0;
        while ($x1 < count($universe)) {
            while ($y1 < strlen($universe[$x1])) {
                if ($universe[$x1][$y1] == '#') {
                    $x2 = ($y1 == strlen($universe[$x1]) - 1) ? $x1 + 1: $x1;
                    $y2 = ($y1 == strlen($universe[$x1]) - 1) ? 0: $y1;
                    while ($x2 < count($universe)) {
                        while ($y2 < strlen($universe[$x2])) {
                            if ($universe[$x2][$y2] == '#') {
                                if ($y2 == $y1) {
                                    // shortest path would be just row 
                                    $counter += abs($x1 - $x2);
                                }
                                elseif ($x2 == $x1) {
                                    $counter += abs($y1 - $y2);
                                }
                                else {
                                    $counter += abs($x2 - $x1) + abs($y2 - $y1);
                                }
                            }
                            $y2++;
                        }
                        $y2 = 0;
                        $x2++;
                    }
                }
                $y1++;
            }
            $y1 = 0;
            $x1++;
        }
        var_dump($counter);
    }
    stepCounter($data);
?>
