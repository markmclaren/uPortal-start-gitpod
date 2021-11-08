FROM gitpod/workspace-full

RUN bash -c ". /home/gitpod/.sdkman/bin/sdkman-init.sh && sdk list"
# RUN bash -c ". /home/gitpod/.sdkman/bin/sdkman-init.sh && sdk install java 12.0.1.j9-adpt && sdk ..."