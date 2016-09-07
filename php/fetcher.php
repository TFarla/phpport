<?php

$f = fopen('php://stdin', 'r');
while($line = fgets($f)) {
    echo implode(',', range(1, 20));
}

fclose($f);
