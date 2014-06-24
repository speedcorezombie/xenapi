#!/bin/bash

source ./conf.sh

# Generate query id
queryid_gen

# Start with outputting the HTTP headers.
echo "Content-type: text/plain; charset=iso-8859-1"
echo

log "Processing query: '${QUERY_STRING}' from: ${REMOTE_ADDR}"
# Get action field froq query
ACTION=`echo "$QUERY_STRING" | $SED -n 's/^.*action=\([^&]*\).*$/\1/p' | $SED "s/%20/ /g"`

# Check action validity
if [ ${ACTION} != "create" ] && [ ${ACTION} != "destroy" ]; then
	error "Undefined or empty action"
fi


