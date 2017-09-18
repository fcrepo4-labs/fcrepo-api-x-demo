<?php
    /* For API-X to load extension definition */
    if ($_SERVER['REQUEST_METHOD'] == "OPTIONS") {
        header("Content-Type: text/turtle");
        readfile("options.ttl");
        return;
    }

    set_include_path(get_include_path() . PATH_SEPARATOR . './lib/');
    require_once "EasyRdf.php";


    function getGraph($resource) {

        $headers = array();
        foreach($_SERVER as $key => $value) {
            if (strpos($key, 'HTTP_') === 0 && $key !== "HTTP_ACCEPT") {
                $header = str_replace(' ', '-', ucwords(str_replace('_', ' ', strtolower(substr($key, 5)))));
                $headers[] = $header . ": " . $value;
            }
        }
        
        $headers['Accept'] = "Accept: application/n-triples";

        $curl = curl_init($resource);
        curl_setopt($curl, CURLOPT_HTTPHEADER, $headers);
        curl_setopt($curl, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($curl, CURLOPT_FOLLOWLOCATION, true);
    
        $rdf = curl_exec($curl);
        $httpCode = curl_getinfo($curl, CURLINFO_HTTP_CODE);
        
        
        if ($httpCode <= 200 || $httpCode > 299) {
            error_log("Got bad error code" . $httpCode);
            http_response_code($httpCode);
            exit("Could not retrieve <" . $resource . ">; code " . $httpCode . "\n Body: " . $rdf );
        }

        $graph = new EasyRdf_Graph();
        $graph->parse($rdf, "nt");

        return $graph;
    }

    $path = preg_replace('/^\/rdfVis/', '', $_SERVER['REQUEST_URI']);
    $resource = $_SERVER['HTTP_APIX_RESOURCE'];

    if ($path == "/image") {
        
        $graph = getGraph($resource);

        $gv = new EasyRdf_Serialiser_GraphViz();
        $format = EasyRdf_Format::getFormat("svg");
        header("Content-Type: ".$format->getDefaultMimeType());
        echo $gv->renderImage($graph, $format);
        return;
    } else if ($path == "/text") {
        $graph = getGraph($resource);

        $ttl = new EasyRdf_Serialiser_Turtle();
        echo $ttl->serialise($graph, "turtle");
        header("Content-Type: text/plain");
        return;
    }

    header("Content-Type: text/html");
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
