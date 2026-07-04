# 📖 The Genesis of Legacy: An Engineering Story

## 🐧 The Spark: Obsolete Silicon
This project started with a problem: two gifted, old iMacs and a salvaged Dell Inspiron 560 tower that the world considered electronic waste. To a computer science student, it was a blank canvas. 
The mission was to take disparate operating systems (macOS, Linux Mint, Alpine Linux, Arch, and Debian) and forge them into a single, cohesive, enterprise-grade development pipeline.

## 🛠️ Breakthroughs & Battle Scars

### 1. The Alpine RAM-Disk Edge Node
Getting the Dell Inspiron tower to operate reliably meant stripping away the overhead. Deploying a minimal Alpine Linux footprint that boots completely out of a RAM-disk via a Ventoy USB allowed the 
system to remain highly resilient against disk degradation, transforming a legacy desktop into an immutable edge node.

### 2. Eliminating the "Loose Script" Chaos
In the early days, the Odysseus backend was triggered by running unstructured Python files locally across terminals. By migrating the service into a dedicated Docker container environment on the 
Linux Mint host and mapping loopbacks cleanly over an encrypted SSH tunnel (`tunnel-odysseus`), the backend became a true isolated local microservice.

### 3. The Unified Viewpoint
Writing individual shell scripts to check resource usage across five different environments was unmaintainable. Integrating Prometheus node-exporters across every guest VM and hardware layer—and 
piping them to a centralized Grafana dashboard—proved that you don't need expensive modern cloud instances to achieve world-class infrastructure observability.

## 🧠 Lessons Learned
Building this homelab taught me that systems engineering isn't about using the newest, most expensive hardware; it's about mastering resource constraints, securing your networking paths, and writing 
repeatable automation. Every configuration file in this repository was written to prove that old hardware can still run modern workloads flawlessly.
