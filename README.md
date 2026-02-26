<!--*************************************************************************-->
<!--                                        ::::::::    ::::::::   ::::::::: -->
<!-- README.md                            :+:    :+:  :+:    :+:  :+:        -->
<!--                                           +:+         :+:   :+:         -->
<!-- github.com/d-branco                    +#+         +#+      +#+#+#+     -->
<!--                                     +#+         +#+              +#+    -->
<!-- Created: 2026/02/26 09:16:22      #+#         #+#      +#+        #+#   -->
<!-- Updated: 2026/02/26 09:16:22     #########  #########  ###      ###     -->
<!--                                                          ########       -->
<!--*************************************************************************-->

_This project has been created as part of the 42 curriculum by abessa-m._

<!--*************************************************************************-->
<!--                                        ::::::::    ::::::::   ::::::::: -->
<!-- README.md                            :+:    :+:  :+:    :+:  :+:        -->
<!--                                           +:+         :+:   :+:         -->
<!-- github.com/d-branco                    +#+         +#+      +#+#+#+     -->
<!--                                     +#+         +#+              +#+    -->
<!-- Created: 2026/02/23 13:41:51      #+#         #+#      +#+        #+#   -->
<!-- Updated: 2026/02/23 14:14:49     #########  #########  ###      ###     -->
<!--                                                          ########       -->
<!--*************************************************************************-->

# Inception: A Docker Story

Welcome to **Inception**, where we don't steal secrets from dreams, but rather orchestrate a tiny, resilient digital city using Docker, `docker-compose`, and a lot of caffeine. This project is a deep dive into system administration, virtualization, and containerization. 

The goal? To deploy a robust, multi-service web infrastructure from scratch, entirely contained within Alpine Linux boxes, without ever typing `apt-get install` on the host machine.

---

## The Description (What on Earth is This?)

Instead of running everything on bare metal like a cave dweller, we've shoved our infrastructure into isolated, purpose-built containers. 

### The Mandatory Trio
* **NGINX (The Strict Bouncer):** The sole entry point to our infrastructure. It only speaks HTTPS (TLSv1.2/v1.3) on port 443. If you come knocking on port 80, it will politely ignore you.
* **WordPress + php-fpm (The Demanding Celebrity):** The core application. It has no idea how to talk to the outside world directly (that's NGINX's job) and relies entirely on MariaDB for memory.
* **MariaDB (The Introverted Archivist):** The database. It sits quietly in the background, only talking to WordPress, hoarding data, and never seeing the light of the internet.

### The Bonus Brigade
Because doing the bare minimum is boring, this project also features five additional containers, each meticulously configured from scratch:
* **Redis (The Speedster):** An in-memory data structure store configured as an object cache for WordPress. It intercepts and stores repetitive MariaDB queries, drastically reducing database load and making page renders lightning-fast.
* **FTP Server (The Delivery Guy):** Utilizing `vsftpd`, this service is configured to point directly to the `/var/www/html` volume. It allows secure, direct file management (uploading themes, plugins, or cat pictures) without ever needing to `docker exec` into the WordPress container (available on port 21).
* **Adminer (The Database Mechanic):** A brilliant, single-PHP-file alternative to phpMyAdmin. Running in its own isolated container, it provides a full Graphical User Interface to visually manage MariaDB tables and users (available on port 8084).
* **Static Website (The Portfolio):** A custom-built, lightweight website completely independent from WordPress and PHP. It's served cleanly using Python's built-in HTTP server, demonstrating how to host pure HTML/CSS without bulky frameworks (available on port 225).
* **Dozzle (The Watchman):** A sleek, zero-configuration web application that mounts the host's Docker socket (`/var/run/docker.sock`). It provides a real-time, searchable, and beautiful web-based log viewer for all your containers, saving you from endlessly typing `docker logs -f` (available on port 8085).

---

## Instructions (How to Make It Go Brrr)

This infrastructure is designed to be spin-up-able with a single command. Think of it like assembling IKEA furniture, but all the parts actually fit together.

### 1. Pre-flight Checks
You need to trick your computer into thinking `abessa-m.42.fr` is a real place. Add this to your `/etc/hosts` file (requires root):
```bash
127.0.0.1   abessa-m.42.fr
```

### 2. The Secret Sauce (`.env`)
You need a `.env` file in the `srcs/` directory. It should look something like this (but with better passwords):
```env
# Domain
DOMAIN_NAME=abessa-m.42.fr

# Paths
DATA_PATH=/home/abessa-m/data

# Database Setup
DB_NAME=wordpress
DB_ROOT_PASSWORD=super_secret_root
DB_USER=sandra
DB_PASSWORD=super_secret_sandra

# ... other variables for WP, FTP, Redis, etc.
```

### 3. Execution
Navigate to the root of the repository and run the Makefile. 

* **To build and start the entire city:**
  ```bash
  make
  # or
  make all
  ```
* **To stop the city (but keep the buildings):**
  ```bash
  make down
  ```
* **To stop the city, demolish the buildings, and burn the blueprints (nuclear option):**
  ```bash
  make fclean
  ```

---

## The Great Comparisons (Apples vs. Oranges)

Evaluators love this part. Here is the exhaustive breakdown of why we made the choices we did.

### Virtual Machines vs. Docker
* **The Heavyweight Champion vs. The Nimble Ninja.** 
* **VMs** emulate an entire computer system, including the hardware and a full Guest OS. They are heavy, slow to boot, and consume a massive amount of resources. 
* **Docker Containers**, on the other hand, share the host machine's OS kernel. They don't need a hypervisor. They are lightweight, start in milliseconds, and package only the application and its dependencies. If a VM is a standalone house, a container is an apartment in a high-rise.

### Secrets vs. Environment Variables
* **James Bond vs. Sticky Notes on the Monitor.**
* **Environment Variables** (`.env`) are great for configuration (like setting a domain name), but they can easily leak into logs or be exposed if an application crashes and dumps its environment. 
* **Docker Secrets** are the actual, secure way to handle passwords. They are encrypted at rest, transmitted securely, and mounted as in-memory files (usually in `/run/secrets/`) inside the container. We used `.env` here because it was allowed, but in the real world, we'd use secrets.

### Docker Network vs. Host Network
* **The VIP Lounge vs. The Public Square.**
* **Host Network** (`network: host`) removes network isolation. The container shares the host's networking namespace. It's fast, but dangerous—port conflicts are a nightmare, and there's zero security boundary.
* **Docker Bridge Network** (what we used: `inception`) creates a private, isolated internal network. NGINX, WordPress, and MariaDB can talk to each other using their container names as DNS, but the host machine (and the outside world) can only access what we explicitly publish (like port 443 on NGINX).

### Docker Volumes vs. Bind Mounts
* **The Secure Vault vs. The Shared Drive.**
* **Bind Mounts** rely on the host machine's directory structure (e.g., mapping `/home/user/data` to `/var/www/html`). If the host path changes, or permissions get weird, the container breaks.
* **Docker Volumes** are entirely managed by Docker. They are stored in a part of the host filesystem that is managed by Docker (`/var/lib/docker/volumes/`). They are easier to back up, safer, and work identically across different operating systems. We used a hybrid approach (local driver with a bind mount) to satisfy the specific `DATA_PATH` requirement of the subject.
 Integration
---

## Resources (Who Actually Wrote This?)

Building a tiny digital city requires a lot of reading. Here are the sacred texts:
* [A Docker Visual Guide](https://learn-how-docker-works.vercel.app/)
* [A Tutorial by Alejiri](https://dev.to/alejiri/docker-nginx-wordpress-mariadb-tutorial-inception42-1eok)
* [Some Examples](https://github.com/docker/awesome-compose/tree/master)
* [WordPress and php-fpm](https://wordpress.org/support/article/nginx/)

### AI Usage Disclosure
As required by the curriculum, I must disclose that Artificial Intelligence (specifically, an LLM) was consulted during thitheir owns project. It was primarily used to:

1. **Clarify documentation to a level a novice could understand:** The AI helped translate dense, cryptic Docker documentation and arcane `php-fpm` configurations into plain, readable English so that anyone (like this total beginner) could grasp the underlying concepts.
2. **Confabulate unexisting versions of Alpine:** During the planning phase, the AI hallucinated and enthusiastically suggested Alpine `v3.23` was the last, forcing me to manually verify the actual "penultimate stable version" requirement against reality.
3. **Suggest overengineering solutions to trivial problems:** When asked how to serve a simple folder of static HTML files, the AI initially proposed a multi-stage build compiling a custom Rust web server with load balancing and Prometheus metrics. I had to rein it in and remind it that `python3 -m http.server` exists.
4. **Analyze and criticize the last written code:** The AI brutally reviewed my `static` container implementation. It pointed out that my `setup.sh` script (`exec python3 -m http.server 8080`) is technically robust because it uses `exec` to properly replace the shell process (handling PID 1 signals correctly), but it criticized the Dockerfile for running `apk update` before `apk add --no-cache`, noting that `--no-cache` inherently bypasses the need for a separate update step, making the `apk update` redundant and a waste of image build time.

### Human Stupidity Disclosure
For contrast, balance, and absolute transparency, I must also disclose the primary source of errors during this project: myself. Human stupidity was primarily used to:

1. **Reintroduce previously vanquished bugs:** By blindly copy-pasting an "improved" NGINX configuration from a two-year-old forum post, I successfully resurrected a 502 Bad Gateway error that I had already solved and banished three days prior.
2. **Idealize Debian "Bookworm":** I spent an embarrassing amount of time contemplating rewriting all eight Dockerfiles from Alpine Linux to Debian, entirely because "Bookworm" sounds like a much cooler operating system name than "3.21".
3. The Background Process Massacre: I wrote an elegant entrypoint script that triumphantly ended with nginx &, only to stare in pure confusion as the container immediately exited with Code 0. It took an embarrassing amount of time to realize that when PID 1 finishes reading a script, the container shuts down, instantly assassinating my perfectly healthy background processes.
4. **Lose sanity over whitespace:** I lost three hours of my life to a "missing separator" Makefile error, violently cursing at `docker-compose`, only to discover I had used four spaces instead of a tab on line 12.
5. **Hardcode my own username:** I initially hardcoded `/home/abessa-m/data` directly into the `docker-compose.yaml` volume definitions, guaranteeing the project would immediately crash and burn the second I tried to run it on another machine.
