<?php
    if ($_SERVER['REQUEST_METHOD'] == "OPTIONS") {
        header("Content-Type: text/turtle");
        readfile("options.ttl");
    } else {
        echo "Hi there!";
    }
?>
