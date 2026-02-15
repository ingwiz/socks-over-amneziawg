# AmneziaWG + Dante SOCKS5 (Docker Compose)

Run **AmneziaWG (WireGuard-based VPN client)** together with a **Dante SOCKS5 proxy** in Docker.

All SOCKS5 traffic is routed through the VPN tunnel.

---

## 📦 Configuration

The project includes a ready-to-use `.env` file:

```env
# Path to AmneziaWG configuration file (mounted read-only inside container)
CONF=./awg.conf

# Local port where SOCKS5 will be exposed (binds to 127.0.0.1 only)
SOCKS_PORT=2081
```

> ⚠️ **Important:**
> Do **not** use a symlink or hardlink as the VPN configuration file.
> Docker Desktop (especially under WSL2) may cache bind mounts and not detect updates correctly.
> Always use a regular file to avoid configuration reload issues.

---

## 🚀 Start

```bash
docker compose up -d --build
```

---

## 🏗 How It Works

* `amneziawg` creates the `wg0` interface
* Healthcheck verifies that `wg0` exists
* `socks5` (Dante) shares the same network namespace
* All SOCKS traffic goes through the VPN tunnel
* `amneziawg` continuously checks VPN tunnel state and reports status in container logs

SOCKS is available at:

```
127.0.0.1:2081
```

---

## 🧪 Monitoring

You can monitor VPN state via logs:

```bash
docker compose logs -f amneziawg
```

The container periodically verifies tunnel health and reports connectivity status.

---

## 🖥 Tested Environment

Developed and tested with:

* WSL2
* Docker Desktop

A standard Linux host with Docker should work as well (requires `/dev/net/tun` support).

---

## 🧪 Test

```bash
curl --socks5-hostname 127.0.0.1:2081 https://ifconfig.me
```

You should see your VPN IP address.

---

## 🔐 Requirements

* Linux environment (native or via WSL2)
* Docker + Docker Compose
* `/dev/net/tun` support
* `NET_ADMIN` capability (required for VPN and routing)

---

## 📄 License

MIT (or your preferred license)
