#!/bin/sh
CMD="curl --write-out %{http_code} --silent -o /dev/stderr -dservice.uri=http://$(hostname -i):${PORT}/rdfVis http://apix/services//apix:load"
echo "#empty" > /etc/hosts
register() {
    echo "Registering extension via ${CMD}"
    RESULT=$(${CMD})
    until [ ${RESULT} -lt 400 ] && [ ${RESULT} -gt 199 ]
    do
        echo "Trying again, result was ${RESULT}"
        RESULT=$(${CMD})
        sleep 1
    done

    echo "Done: ${RESULT}"
}

register &

/usr/bin/php7 -S 0.0.0.0:${PORT} -t /www
