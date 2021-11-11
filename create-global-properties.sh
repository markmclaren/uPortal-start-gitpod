#!/bin/bash 
cat << EOF > ./portal/global.properties
## Portal Server
portal.protocol=https
portal.server=${PORTAL_URL:8}
portal.context=/uPortal
## Central Authentication Service (CAS)
cas.protocol=https
cas.server=${PORTAL_URL:8}
cas.context=/cas
EOF