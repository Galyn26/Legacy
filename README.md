# Legacy 🖥️🚀

What started as pure curiosity and a couple of gifted, obsolete machines has evolved into a fully automated, multi-node hybrid cloud platform. This infrastructure features containerized AI services, 
automated SSH hop-routing via a secure mesh overlay, and native cross-platform telemetry monitoring.

This repository serves as the unified infrastructure control plane and configuration source of truth for the entire bare-metal pipeline.

---

## 🏗️ Hardware Topology

* **The Cockpit (2017 iMac):** The central macOS operator workstation where the entire laboratory is orchestrated, monitored, and developed.
* **The Engine (2009 iMac):** Stripped and revived with Linux Mint MATE. Maxed at 16GB RAM, serving as the core compute hypervisor hosting headless development environments and containerized 
backends.
* **The Micro Cockpit (Dell Inspiron 560):** A salvaged headless edge node running Alpine Linux entirely out of RAM via a 64GB Ventoy USB deployment, acting as a persistent automation anchor.

---

## 🌐 Infrastructure, Networking & Core Services

* **Mesh Topology:** A secure Tailscale overlay network binds the macOS workspace, Linux hypervisor, and Alpine edge node into a unified network, allowing direct SSH access (`ssh arch-vm`) from 
anywhere.
* **SSH ProxyJump Mechanics:** Guest VMs (`arch-vm`, `debian-vm`) are safely isolated inside an internal network subnet on the hypervisor, securely accessed via automated SSH hop-routing through the 
Linux Mint host.
* **Containerized AI Runtime:** The Odysseus AI platform has been fully containerized within a Docker environment on the Engine host, securely mapped back to the macOS Cockpit via an encrypted local 
SSH tunnel on port `7777`.
* **Cross-Distro Automation:** Ansible playbooks handle automated infrastructure state configuration, package management across divergent package systems (`pacman`, `apt`), and unified SSH public 
key injection.

---

## 📊 Global Telemetry & Observability Matrix

The infrastructure maintains a terminal-native, single-pane-of-glass monitoring matrix scraping performance data every 15 seconds:

| Service | Port | Scope | Role |
| :--- | :--- | :--- | :--- |
| **Node Exporter** | `9100` | Global (All Nodes) | Pulls bare-metal and kernel hardware metrics |
| **Prometheus** | `9090` | Docker (Mint Host) | Automated time-series scraping database |
| **Grafana** | `3000` | Docker (Mint Host) | Multi-node visualization dashboards (UI ID: 1860) |

---

## 📚 Deep Research & Whitepapers

As part of the design and hardening phases of this laboratory, deep technical research was conducted into the underlying security layers of multi-tenant environments:

* **[Whitepaper: Modern Multi-Tenant Linux Virtualization Security & Environment Masking via `socat`](docs/linux-virtualization-security-socat.pdf):** An in-depth analysis looking at hypervisor 
isolation boundaries, kernel-level tenant segregation, and utilizing `socat` for advanced network socket manipulation, traffic relaying, and environment footprint masking.

---

## 🛠️ Repository Mapping

* `/ansible` - Playbooks for cross-distro package synchronization and secure key injection.
* `/ssh` - Host configurations and automated ProxyJump routing definitions.
* `/shell` - Live tmux lifecycle dashboards, custom terminal bootstrap configurations, and automation macros.
* `/AI` - Local model blueprints and engineering parameters.
* `/docs` - Canonical architectural maps and security research whitepapers.

---

## 📖 The Journey Behind the Build
Want to know how this infrastructure was pieced together from legacy silicon? Check out the complete engineering narrative in [STORY.md](STORY.md).
