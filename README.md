# Legacy 🖥️🚀

What started as pure curiosity and two gifted, obsolete iMacs has evolved into a fully automated, multi-OS hybrid cloud infrastructure with native terminal observability and local AI integration. 

This repository serves as the definitive configuration archive for the entire bare-metal pipeline.

---

## 🏗️ Hardware Topology

* **The Engine (2009 iMac):** Wiped completely and revived with Linux Mint MATE. Maxed at 16GB RAM, serving as the primary hypervisor hosting headless Arch Linux and Debian environments.
* **The Cockpit (2017 iMac):** The central macOS frontend platform where the entire laboratory is orchestrated, monitored, and developed.

---

## 🌐 Infrastructure & Networking Blueprint

* **Automation:** Ansible playbooks handle state configuration, package synchronization, and seamless SSH key injection across different package managers (`pacman`, `apt`).
* **Mesh Networking:** A secure Tailscale overlay network binds the macOS frontend and the Linux backend together, allowing direct, native SSH tunneling (`ssh arch-vm`) from anywhere.
* **Port Forwarding:** Custom backgrounded tunnels handle communication via the `odysseus` protocol to route backend Python services directly to the management interface.

---

## 🛠️ Repository Mapping
* `/ansible` - Playbooks for cross-distro synchronization.
* `/ssh` - Host shortcut configurations.
* `/shell` - Laboratory control macros and lifecycle aliases.

---

## ⚠️ Disclaimer
> [!NOTE]
> The directory structure and contents of this repository are currently tentative and highly prone to change. The repository owner is actively tracing and scraping configuration files across the infrastructure environment to piece together the definitive deployment pipeline.