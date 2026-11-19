#!/bin/bash
# apt helpers for CI containers, shared by ci.yml and release.yml.
#   ci/apt.sh setup             mirror, retries and timeouts
#   ci/apt.sh install PKG...    apt-get update + install, retried
set -euo pipefail

case "${1:-}" in
    setup)
        # Canonical's and Azure's Ubuntu mirrors drop connections from GitHub runners; use a CDN-backed one
        if [ -f /etc/apt/sources.list.d/ubuntu.sources ]; then
            sed -i -E 's#http://[a-z.]*ubuntu\.com/ubuntu/?#http://mirrors.edge.kernel.org/ubuntu/#' \
                /etc/apt/sources.list.d/ubuntu.sources
        fi
        # Recommends are not needed to verify an install and double the download
        printf '%s\n' \
            'Acquire::Retries "5";' \
            'Acquire::http::Timeout "30";' \
            'APT::Install-Recommends "false";' \
            > /etc/apt/apt.conf.d/80-ci
        ;;
    install)
        shift
        export DEBIAN_FRONTEND=noninteractive
        # Downloaded .debs stay cached, so each attempt only fetches what is still missing
        for attempt in 1 2 3; do
            if apt-get update --error-on=any && apt-get install -y "$@"; then
                exit 0
            fi
            echo "apt attempt $attempt/3 failed, retrying in 30s..."
            sleep 30
        done
        exit 1
        ;;
    *)
        echo "usage: $0 setup | install PKG..." >&2
        exit 2
        ;;
esac
