<?php
    /* For API-X to load extension definition */
    if ($_SERVER['REQUEST_METHOD'] == "OPTIONS") {
        header("Content-Type: text/turtle");
        readfile("options.ttl");
        return;
    }

    set_include_path(get_include_path() . PATH_SEPARATOR . './lib/');
    require_once "EasyRdf.php";

    $path = preg_replace('/^\/rdfVis/', '', $_SERVER['REQUEST_URI']);
    $resource = $_SERVER['HTTP_APIX_RESOURCE'];

    if ($path == "/image") {
        $graph = new EasyRdf_Graph($resource);
        $graph->load();
        $gv = new EasyRdf_Serialiser_GraphViz();
        $format = EasyRdf_Format::getFormat("svg");
        header("Content-Type: ".$format->getDefaultMimeType());
        echo $gv->renderImage($graph, $format);
        return;
    } else if ($path == "/text") {
        $graph = new EasyRdf_Graph($resource);
        $graph->load();
        $ttl = new EasyRdf_Serialiser_Turtle();
        echo $ttl->serialise($graph, "turtle");
        header("Content-Type: text/plain");
        return;
    }

    header("Content-Type: text/html")
?>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Visualizing</title>
</head>

<body>
    <h2>Pick a format</h2>
    <div id="formats">
      <div class="image"><a href="image">View as image</a></dov>
      <div class="text"><a href="text">View as text</a></div>
    </div>
</body>

</html> 
