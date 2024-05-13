#!/bin/bash
#
set -eux -o pipefail

if [ $# -ne 1 ]; then
    echo "Usage: $0 [rosmar|cbs]"
    exit 1
fi

CBS=
case $1 in
    rosmar) ;;
    *)
        CBS=true
        ;;
esac

if [[ -n "${CBS}" ]]; then
    docker exec couchbase couchbase-cli bucket-create --cluster couchbase://localhost --username Administrator --password password --bucket bucket1 --bucket-type couchbase --bucket-ramsize 1000 --wait
    docker exec couchbase couchbase-cli collection-manage --cluster couchbase://localhost --username Administrator --password password --bucket bucket1 --create-scope fooscope
    docker exec couchbase couchbase-cli collection-manage --cluster couchbase://localhost --username Administrator --password password --bucket bucket1 --create-collection fooscope.barcollection
fi

echo "Creating database, building indexes"
time http -v --check-status -a Administrator:password PUT :4985/db/ bucket=bucket1 num_index_replicas:=0 'scopes[fooscope][collections][barcollection]:={}'
echo "Done creating database"

http -v --check-status -a Administrator:password PUT :4985/db.fooscope.barcollection/doc1 foo=bar
