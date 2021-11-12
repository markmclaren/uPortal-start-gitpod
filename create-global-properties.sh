#!/bin/bash 
cat << EOF > ./portal/global.properties
hibernate.connection.driver_class=org.hsqldb.jdbc.JDBCDriver
hibernate.connection.url=jdbc:hsqldb:hsql://localhost:8887/uPortal
hibernate.connection.username=sa
hibernate.connection.password=
hibernate.connection.validationQuery=select 1 from INFORMATION_SCHEMA.SYSTEM_USERS
hibernate.dialect=org.hibernate.dialect.HSQLDialect
## Portal Server
portal.protocol=https
portal.server=${PORTAL_URL:8}
portal.context=/uPortal
## Central Authentication Service (CAS)
cas.protocol=https
cas.server=${PORTAL_URL:8}
cas.context=/cas
EOF