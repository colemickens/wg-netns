
# TODO? #sudo -E ip netns exec ${1} sudo -E -u "$(id -u)" "${@}"


#!/usr/bin/env bash
set -x
set -euo pipefail

CONF_IN="${1}"
WGDEV="wg0"
NETNS="$(basename "${CONF_IN}" .conf)"
shift

sudo -E ip netns exec "${NETNS}" sudo -E -u "${USER}" "${@}"
