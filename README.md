# wg-netns

## Overview

I'm making this public to share it, not to necessarily maintain it. On the one hand, I'd prefer `wg-quick` worked in NixOS properly, but on the other hand, there's something nice about using netns like this.

1. Works on NixOS
2. Auto handles config files
3. Wireguard interface is always wg0
4. Netns is derived from config name
5. Tested with Mullvad. ( see item 6)
6. ~~Handles DNS (aka no leaks?)~~ See https://github.com/colemickens/wg-netns/issues/1

## Usage

```bash
# start netns, connect wireguard
sudo ./wg-up.sh ./mullvad-us40.conf

# run a command in the netns
# try to import the env (this makes... everything? work as expected, even in NixOS)
./run.sh mullvad-us40.conf \
  firefox --no-remote -p mullvad-profile

# later
sudo ./wg-down.sh mullvad-us40

```

