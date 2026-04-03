# relay-manager

CLI utility for managing port forwarding on relay/jump servers. Designed for proxying traffic to backend servers running 3x-ui, xray-core, sing-box, etc.

## Features

- **Interactive & scriptable** — add/remove ports via CLI args or interactive prompts
- **Firewall-aware** — auto-manages `ufw` and `firewalld` rules
- **Persistent** — rules survive reboots via `iptables-persistent` + config files
- **UFW NAT integration** — auto-rebuilds `/etc/ufw/before.rules` when UFW is active
- **One-command deploy** — install from GitHub in one line
- **Status & diagnostics** — see what's forwarded, check reachability, inspect iptables

## Architecture

```
Client ──→ Relay Server (relay-manager) ──→ Backend Server (3x-ui)
           IP: 1.2.3.4                      IP: 10.0.0.2
           Ports: 443, 2053                  Ports: 443, 2053
```

The relay server transparently forwards traffic using iptables DNAT + MASQUERADE. Clients connect to the relay IP — they never see the backend.

## Install

```bash
curl -fsSL https://raw.githubusercontent.com/YOUR_USER/relay-manager/main/install.sh | sudo bash
```

Or manually:

```bash
git clone https://github.com/YOUR_USER/relay-manager.git
sudo cp relay-manager/relay /usr/local/bin/relay
sudo chmod +x /usr/local/bin/relay
```

## Quick start

```bash
# 1. Initial setup
sudo relay init

# 2. Add forwarding rules
sudo relay add 443 tcp "VLESS+Reality"
sudo relay add 443 udp "VLESS+Reality"
sudo relay add 2053 tcp "3x-ui panel"

# Or use 'both' for TCP+UDP at once
sudo relay add 8443 both "Hysteria2"

# Or interactive mode
sudo relay add

# 3. Check status
relay list
relay status
```

## Commands

| Command | Description |
|---------|-------------|
| `relay init` | Initial setup — target IP, interface, ip_forward, iptables-persistent |
| `relay add [port] [proto] [desc]` | Add forwarding rule (interactive if no args) |
| `relay remove [port] [proto]` | Remove forwarding rule |
| `relay list` | List all configured rules with live status |
| `relay status` | System diagnostics — forwarding, firewall, reachability |
| `relay apply` | Re-apply all rules from config (useful after reboot issues) |
| `relay flush` | Remove all forwarding rules |
| `relay uninstall` | Complete removal |

## Protocols

| Proto | Use case |
|-------|----------|
| `tcp` | VLESS, VMess, Trojan, Shadowsocks, 3x-ui panel |
| `udp` | Hysteria, Hysteria2, TUIC, VLESS+Reality (QUIC) |
| `both` | Shorthand for TCP + UDP on same port |

## Files

| Path | Purpose |
|------|---------|
| `/etc/relay-manager/config` | Target IP, interface |
| `/etc/relay-manager/rules` | Port forwarding rules |
| `/etc/iptables/rules.v4` | Persisted iptables rules |

## Example session

```
$ sudo relay init

  ┌─────────────────────────────────────┐
  │     relay-manager — initial setup   │
  └─────────────────────────────────────┘

?  Target server IP (3x-ui): 10.0.0.2
✔  Target 10.0.0.2 is reachable
?  Network interface [eth0]:
✔  IP forwarding already enabled
✔  Config saved to /etc/relay-manager/config

$ sudo relay add 443 both "VLESS+Reality"
✔  Added: 443/tcp → 10.0.0.2:443  (VLESS+Reality)
✔  Added: 443/udp → 10.0.0.2:443  (VLESS+Reality)
ℹ  iptables rules persisted

$ relay list

  relay-manager v1.0.0
  Target: 10.0.0.2
  Interface: eth0
  Firewall: ufw (active)

  PORT     PROTO    DESCRIPTION                    STATUS
  ──────────────────────────────────────────────────────────
  443      tcp      VLESS+Reality                  active
  443      udp      VLESS+Reality                  active
```

## Compatibility

- Ubuntu 22.04+ / Debian 12+
- Works with iptables (nftables backend)
- Supports `ufw` and `firewalld`

## License

MIT
