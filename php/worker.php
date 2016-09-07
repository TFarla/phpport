<?php
$f = fopen('php://stdin', 'r');
while($line = fgets($f)) {
    $ids = explode(',', trim($line));
    echo implode(',', array_map(function($id) {
        return $id + 1;
    }, $ids));
}

fclose($f);
