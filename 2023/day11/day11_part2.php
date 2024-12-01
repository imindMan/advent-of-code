<?php
    $myfile = fopen("day11.txt", "r") or die("Unable to open file!");
    // Output one line until end-of-file
    $data = [];
    while(!feof($myfile)) {
        $data[] = substr_replace(fgets($myfile), '', -1);
    }
    fclose($myfile);
    array_pop($data);

    function extendUniverse($universe) {
        // row addition
        $row = [];
        for ($x = 0; $x < count($universe); $x++) {
            if (strpos($universe[$x], '#') === false) {
                $row[] = $x;
            }
        }
        # column addition
        $col = [];
        for ($y = 0; $y < strlen($universe[0]); $y++) {
            $col_check = "";

            foreach ($universe as $row_) {
                $col_check .= $row_[$y];
            }
            if (strpos($col_check, '#') === false) {
                $col[] = $y;
            }
        } 
        return array($row, $col); 
    }
    function stepCounter($universe, $extend_universe) {
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
                            $n = 999999;
                            if ($universe[$x2][$y2] == '#') {
                                if ($y2 == $y1) {
                                    // shortest path would be just row
                                    $row_adder = 0;
                                    foreach ($extend_universe[0] as $row_check) {
                                        if ( ($x2 <= $x1 && $x2 <= $row_check && $row_check <= $x1)
                                            || ($x1 <= $x2 && $x1 <= $row_check && $row_check <= $x2) ) {
                                            $row_adder += $n;
                                        }
                                    }
                                    $counter += abs($x1 - $x2) + $row_adder;
                                }
                                elseif ($x2 == $x1) {
                                    $col_adder = 0;
                                    foreach ($extend_universe[1] as $col_check) {
                                        if ( ($y2 <= $y1 && $y2 <= $col_check && $col_check <= $y1 )
                                            || ($y1 <= $y2 && $y1 <= $col_check && $col_check <= $y2) ) {
                                            $col_adder += $n;
                                        }
                                    }
                                    $counter += abs($y1 - $y2) + $col_adder;
                                }
                                else {
                                    $x1_calc = $x1;
                                    $y1_calc = $y1;
                                    $x2_calc = $x2;
                                    $y2_calc = $y2;

                                    foreach ($extend_universe[0] as $row_check) {
                                        if ($row_check < $x1) {
                                            $x1_calc += $n;
                                        } 
                                        if ($row_check < $x2) {
                                            $x2_calc += $n;
                                        }
                                    }
                                    foreach ($extend_universe[1] as $col_check) {
                                        if ($col_check < $y1) {
                                            $y1_calc += $n;
                                        } 
                                        if ($col_check < $y2) {
                                            $y2_calc += $n;
                                        }
                                    }
                                    $counter += abs($x2_calc - $x1_calc) + abs($y2_calc - $y1_calc);
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
    stepCounter($data, extendUniverse($data));
?>
