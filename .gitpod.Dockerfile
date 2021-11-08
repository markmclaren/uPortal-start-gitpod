FROM gitpod/workspace-full

# RUN bash -c ". /home/gitpod/.sdkman/bin/sdkman-init.sh && sdk list java"
RUN bash -c ". /home/gitpod/.sdkman/bin/sdkman-init.sh && sdk install java 8.0.292.hs-adpt"