#!/usr/bin/env bash
set -x
set -euo pipefail

CONF_IN="${1}"
WGDEV="wg0"
NETNS="$(basename "${CONF_IN}" .conf)"

sudo ip netns exec "${NETNS}" ip link del dev "${WGDEV}" || true
sudo ip netns del "${NETNS}" || true
sudo rm -rf "/etc/netns/${NETNS}"

