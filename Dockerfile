# Hardened GitHub Actions runner image: official actions-runner 2.338.2 with three changes.
#  1. apt: Ubuntu security updates for libbrotli1, apt and libapt-pkg6.0t64 (noble-security), not yet in upstream image.
#  2. npm removed from bundled Node runtimes (externals/node20, node24): the runner executes action JS only, not npm.
#  3. docker, dockerd, containerd, runc, ctr and buildx removed: the target platform provides no container socket.
# User (runner, uid 1001) and entrypoint unchanged.
ARG BAZA=ghcr.io/actions/actions-runner@sha256:0ce3288e48b012a83685998f683a2ae0cbd284fa722c090dda0af5443215cf30
FROM ${BAZA}
USER root
RUN apt-get update \
 && apt-get install -y --no-install-recommends --only-upgrade libbrotli1 apt libapt-pkg6.0t64 \
 && apt-get clean \
 && rm -r /var/lib/apt/lists/* \
 && rm -r /home/runner/externals/node20/lib/node_modules/npm /home/runner/externals/node24/lib/node_modules/npm \
 && rm -f /usr/bin/dockerd /usr/bin/docker /usr/bin/containerd /usr/bin/containerd-shim-runc-v2 /usr/bin/ctr /usr/bin/runc \
          /usr/bin/docker-init /usr/bin/docker-proxy /usr/bin/containerd-stress \
 && rm -r /usr/local/lib/docker
USER runner
