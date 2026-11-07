#!/usr/bin/env bash
# Installs this workshop's own command-line tools into its tools image, on top of the
# shared ones (oc, kubectl, helm, jq, yq, git, curl, wget, skopeo, docker shim).
# The image build runs it as root, with TARGETARCH set to amd64 or arm64.
# List each command it installs in tools/extra-tools, one per line.
set -euo pipefail

ISTIO_VERSION=1.27.1
SPIRE_VERSION=1.13.3

# istioctl, matching the Istio that OpenShift Service Mesh 3.4 ships.
curl -sSL "https://github.com/istio/istio/releases/download/${ISTIO_VERSION}/istioctl-${ISTIO_VERSION}-linux-${TARGETARCH}.tar.gz" \
  | tar -xz -C /usr/local/bin istioctl

# spire-server and spire-agent CLIs, to run bundle and entry commands
# from the tools pod the same way the pages run them with oc exec.
curl -sSL "https://github.com/spiffe/spire/releases/download/v${SPIRE_VERSION}/spire-${SPIRE_VERSION}-linux-${TARGETARCH}-musl.tar.gz" \
  | tar -xz --strip-components 2 -C /usr/local/bin \
    "spire-${SPIRE_VERSION}/bin/spire-server" \
    "spire-${SPIRE_VERSION}/bin/spire-agent"

# openssl for the handshake checks.
microdnf install -y openssl >/dev/null 2>&1 || dnf install -y openssl
