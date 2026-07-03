terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

provider "docker" {
  host = "tcp://100.74.100.15:2375"
}

# ==============================================================================
# NETWORKING DEFINITIONS (Declaring the missing network boundaries)
# ==============================================================================
resource "docker_network" "odysseus_net" {
  name = "odysseus_default"
}

resource "docker_network" "telemetry_net" {
  name = "telemetry_default"
}

# ==============================================================================
# 1. ODYSSEUS CORE WORKSPACE (Host Network Mode)
# ==============================================================================
resource "docker_container" "odysseus" {
  name         = "odysseus-odysseus-1"
  image        = "odysseus-odysseus"
  restart      = "unless-stopped"
  network_mode = "host"
  working_dir  = "/app"

  command = [
    "uvicorn",
    "app:app",
    "--host",
    "0.0.0.0",
    "--port",
    "7000"
  ]

  lifecycle {
    ignore_changes = [
      ipc_mode, log_driver, runtime, security_opts, stop_signal, 
      user, userns_mode, hostname, domainname, capabilities, env, image, host
    ]
  }
}

# ==============================================================================
# 2. CHROMA VECTOR DATABASE (Bridge Network with Volumes)
# ==============================================================================
resource "docker_container" "chromadb" {
  name         = "odysseus-chromadb-1"
  image        = "chromadb/chroma:latest"
  restart      = "unless-stopped"
  network_mode = docker_network.odysseus_net.name
  shm_size     = 64

  command = ["run", "/config.yaml"]

  ports {
    internal = 8000
    external = 8100
    ip       = "0.0.0.0"
    protocol = "tcp"
  }

  mounts {
    source    = "odysseus_chromadb-data"
    target    = "/chroma/chroma"
    type      = "volume"
    read_only = false
  }

  lifecycle {
    ignore_changes = [
      ipc_mode, log_driver, runtime, security_opts, stop_signal, 
      user, userns_mode, hostname, domainname, env, image
    ]
  }
}

# ==============================================================================
# 3. SEARXNG PRIVACY SEARCH ENGINE (With Dynamic Secret Generation Wrapper)
# ==============================================================================
resource "docker_container" "searxng" {
  name         = "odysseus-searxng-1"
  image        = "searxng/searxng:2026.5.31-7159b8aed"
  restart      = "unless-stopped"
  network_mode = docker_network.odysseus_net.name
  working_dir  = "/usr/local/searxng"

  entrypoint = [
    "/bin/sh",
    "-c",
    <<-EOT
        set -eu
        if [ ! -s /etc/searxng/settings.yml ] || grep -q 
'odysseus-local-searxng-json-2026-05-30\|__SEARXNG_SECRET__' /etc/searxng/settings.yml; then
          secret="$${SEARXNG_SECRET:-}"
          if [ -z "$secret" ]; then
            secret="$(python -c 'import secrets; print(secrets.token_urlsafe(48))')"
          fi
          sed "s|__SEARXNG_SECRET__|$secret|g" /tmp/searxng-settings.yml.template > /etc/searxng/settings.yml
        fi
        exec /usr/local/searxng/entrypoint.sh
    EOT
  ]

  capabilities {
    add  = ["CHOWN", "DAC_OVERRIDE", "SETGID", "SETUID"]
    drop = ["ALL"]
  }

  healthcheck {
    test           = ["CMD-SHELL", "python -c \"import urllib.request; 
urllib.request.urlopen('http://localhost:8080/', timeout=5).read(1)\""]
    interval       = "5s"
    timeout        = "6s"
    retries        = 20
    start_period   = "10s"
    start_interval = "0s"
  }

  ports {
    internal = 8080
    external = 8080
    ip       = "127.0.0.1"
    protocol = "tcp"
  }

  mounts {
    source    = "odysseus_searxng-data"
    target    = "/etc/searxng"
    type      = "volume"
    read_only = false
  }

  lifecycle {
    ignore_changes = [
      ipc_mode, log_driver, runtime, security_opts, stop_signal, 
      user, userns_mode, hostname, domainname, env, image
    ]
  }
}

# ==============================================================================
# 4. NTFY CORE NOTIFICATION AGENT (Bridge Network with Volume)
# ==============================================================================
resource "docker_container" "ntfy" {
  name         = "odysseus-ntfy-1"
  image        = "binwiederhier/ntfy"
  restart      = "unless-stopped"
  network_mode = docker_network.odysseus_net.name
  working_dir  = "/"

  command = ["serve"]

  ports {
    internal = 80
    external = 8091
    ip       = "0.0.0.0"
    protocol = "tcp"
  }

  mounts {
    source    = "odysseus_ntfy-cache"
    target    = "/var/cache/ntfy"
    type      = "volume"
    read_only = false
  }

  lifecycle {
    ignore_changes = [
      ipc_mode, log_driver, runtime, security_opts, stop_signal, 
      user, userns_mode, hostname, domainname, env, image
    ]
  }
}

# ==============================================================================
# 5. ENCRYPTED VAULT SYSTEM DATABASE (PostgreSQL - Fixed Port Collision)
# ==============================================================================
resource "docker_container" "postgres" {
  name         = "mint_vault_db"
  image        = "postgres:latest"
  restart      = "unless-stopped"
  network_mode = "bridge"
  stop_signal  = "SIGINT"

  command = ["postgres"]

  ports {
    internal = 5432
    external = 5432
    ip       = "0.0.0.0"
    protocol = "tcp"
  }

  lifecycle {
    ignore_changes = [
      ipc_mode, log_driver, runtime, security_opts, 
      user, userns_mode, hostname, domainname, env, image
    ]
  }
}

# ==============================================================================
# 6. OBSERVABILITY CORE: PROMETHEUS TELEMETRY ENGINE
# ==============================================================================
resource "docker_container" "prometheus" {
  name         = "telemetry_prometheus"
  image        = "prom/prometheus:latest"
  restart      = "unless-stopped"
  network_mode = docker_network.telemetry_net.name
  working_dir  = "/prometheus"
  user         = "nobody"

  command = ["--config.file=/etc/prometheus/prometheus.yml"]

  ports {
    internal = 9090
    external = 9090
    ip       = "0.0.0.0"
    protocol = "tcp"
  }

  mounts {
    source    = "telemetry_prometheus_data"
    target    = "/prometheus"
    type      = "volume"
    read_only = false
  }

  lifecycle {
    ignore_changes = [
      ipc_mode, log_driver, runtime, security_opts, stop_signal, 
      userns_mode, hostname, domainname, env, image
    ]
  }
}

# ==============================================================================
# 7. OBSERVABILITY VISUALIZATION LAYER: GRAFANA DASHBOARDS
# ==============================================================================
resource "docker_container" "grafana" {
  name         = "telemetry_grafana"
  image        = "grafana/grafana:latest"
  restart      = "unless-stopped"
  network_mode = docker_network.telemetry_net.name
  working_dir  = "/usr/share/grafana"
  user         = "472"

  ports {
    internal = 3000
    external = 3000
    ip       = "0.0.0.0"
    protocol = "tcp"
  }

  mounts {
    source    = "telemetry_grafana_data"
    target    = "/var/lib/grafana"
    type      = "volume"
    read_only = false
  }

  lifecycle {
    ignore_changes = [
      ipc_mode, log_driver, runtime, security_opts, stop_signal, 
      userns_mode, hostname, domainname, env, image
    ]
  }
}

# ==============================================================================
# 8. OBSERVABILITY METRICS COLLECTOR: NODE EXPORTER AGENT
# ==============================================================================
resource "docker_container" "node_exporter" {
  name         = "telemetry_node_exporter"
  image        = "prom/node-exporter:latest"
  restart      = "unless-stopped"
  network_mode = "host"
  user         = "nobody"

  command = [
    "--path.procfs=/host/proc",
    "--path.sysfs=/host/sys",
    "--path.rootfs=/rootfs"
  ]

  lifecycle {
    ignore_changes = [
      ipc_mode, log_driver, runtime, security_opts, stop_signal, 
      userns_mode, hostname, domainname, env, image
    ]
  }
}}
