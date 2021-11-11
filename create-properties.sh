#! /bin/bash
export URL=$(gp url 8080)
cat <<EOF
## Portal Server
portal.protocol=https
portal.server=${URL:8}
portal.context=/uPortal
## Central Authentication Service (CAS)
cas.protocol=https
cas.server=${URL:8}
cas.context=/cas
EOF