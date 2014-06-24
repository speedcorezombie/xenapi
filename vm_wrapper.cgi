#!/bin/bash

source conf.sh

# Generate query id
queryid_gen

# Start with outputting the HTTP headers.
echo "Content-type: text/plain; charset=iso-8859-1"
echo

log "Processing query: '${QUERY_STRING}' from: ${REMOTE_ADDR}"
