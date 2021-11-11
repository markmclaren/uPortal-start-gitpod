#!/bin/bash 
cat << EOF > ./portal/cas.properties
# Services Management Web UI Security
server.name=${PORTAL_URL}
server.prefix=\${server.name}/cas
cas.securityContext.serviceProperties.service=\${server.prefix}/services/j_acegi_cas_security_check
# Names of roles allowed to access the CAS service manager
cas.securityContext.serviceProperties.adminRoles=ROLE_ADMIN
cas.securityContext.casProcessingFilterEntryPoint.loginUrl=\${server.prefix}/login
cas.securityContext.ticketValidator.casServerUrlPrefix=\${server.prefix}
# IP address or CIDR subnet allowed to access the /status URI of CAS that exposes health check information
cas.securityContext.status.allowedSubnet=127.0.0.1
cas.themeResolver.defaultThemeName=cas-theme-default
cas.viewResolver.basename=default_views
##
# Unique CAS node name
# host.name is used to generate unique Service Ticket IDs and SAMLArtifacts.  This is usually set to the specific
# hostname of the machine running the CAS node, but it could be any label so long as it is unique in the cluster.
host.name=${PORTAL_URL:8}
EOF