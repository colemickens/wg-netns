#!/usr/bin/env bash
set -x
set -euo pipefail

CONF_IN="${1}"
WGDEV="wg0"
NETNS="$(basename "${CONF_IN}" ".conf")"

CONF="$(mktemp)"
cp "${CONF_IN}" "${CONF}"

sed -i 's/^Address/#Address/g' "${CONF}"
sed -i 's/^DNS/#DNS/g' "${CONF}"

sudo rm -rf "/etc/netns/${NETNS}"
sudo mkdir -p "/etc/netns/${NETNS}"

sudo ip netns del "${NETNS}" || true
sudo ip netns add "${NETNS}"
sudo ip netns exec "${NETNS}" ip link set lo up

sudo ip link del dev "${WGDEV}" || true
sudo ip link add dev "${WGDEV}" type wireguard

sudo wg setconf "${WGDEV}" "${CONF}"
sudo ip link set "${WGDEV}" netns "${NETNS}" up

# handle DNS=
dns=$(grep -oP "#DNS = \K(.*)" "${CONF}")
echo "nameserver $dns" | sudo tee "/etc/netns/${NETNS}/resolv.conf"

# handle Address=
addrs=$(grep -oP "#Address = \K(.*)" "${CONF}")
IFS=", "; for addr in $addrs; do
  if [[ $addr = *":"* ]]; then
    sudo ip netns exec "${NETNS}" ip -6 addr add $addr dev "${WGDEV}"
  else
    sudo ip netns exec "${NETNS}" ip addr add $addr dev "${WGDEV}"
  fi
done

sudo ip netns exec "${NETNS}" ip route add default dev "${WGDEV}"
sudo ip netns exec "${NETNS}" ip -6 route add default dev "${WGDEV}"

