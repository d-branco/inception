<!--*************************************************************************-->
<!--                                        ::::::::    ::::::::   ::::::::: -->
<!-- DEV_DOC.md                           :+:    :+:  :+:    :+:  :+:        -->
<!--                                           +:+         :+:   :+:         -->
<!-- github.com/d-branco                    +#+         +#+      +#+#+#+     -->
<!--                                     +#+         +#+              +#+    -->
<!-- Created: 2026/02/23 14:14:48      #+#         #+#      +#+        #+#   -->
<!-- Updated: 2026/02/23 14:14:48     #########  #########  ###      ###     -->
<!--                                                          ########       -->
<!--*************************************************************************-->

# Developer Documentation: Rebuilding the Matrix

Welcome to the internal docs for **Inception**. If you're reading this, you probably need to debug a container, understand how Alpine packages actually work, or figure out why MariaDB is refusing to talk to WordPress.

---

## Setting up the Environment from Scratch

This project is built to be reproducible. If you follow these steps, you will build exactly what the creator intended, without any strange magic happening on your host machine.

### Prerequisites (The Tools You Need)
1. **A Linux Machine:** (Preferably Debian or Ubuntu, but any flavor works).
2. **Docker Engine:** Installed and running.
3. **Docker Compose:** The orchestrator (usually installed with Docker Desktop, or available as a plugin).
4. **Make:** The orchestrator's orchestrator.

### Setup Steps
1. **Clone the Repository:** 
   *(You've already done this if you're reading this file locally.)*
2. **Configure Host Resolution:** 
   Add `127.0.0.1   abessa-m.42.fr` to `/etc/hosts` (requires `sudo`). This is how your browser knows where to find the website locally.
3. **The `.env` File:**
   You must create a `.env` file in the `srcs/` directory. This is where all the secrets (passwords, database names, users) are stored. Do **NOT** commit this file to version control.

### The Sacred `.env` Variables
```env
DOMAIN_NAME=abessa-m.42.fr
DATA_PATH=/home/abessa-m/data

# MariaDB / WordPress
DB_NAME=wordpress
DB_ROOT_PASSWORD=your_secure_root_password
DB_USER=sandra
DB_PASSWORD=your_secure_sandra_password

# FTP
FTP_USER=ftpuser
FTP_PASS=ftppassword

# Redis
REDIS_HOST=redis
REDIS_PORT=6379
```

*(Note: The `DATA_PATH` is crucial. The Makefile will attempt to create these directories automatically.)*

---

## Building and Launching (The Makefile)

We do not manually type `docker build` or `docker run` in this house. The `Makefile` at the root of the repository automates everything using `docker-compose`.

### Commands Explained

* **`make` (or `make all`)**
  1. Creates the persistent data directories defined in `DATA_PATH` (e.g., `/home/abessa-m/data/wordpress` and `/home/abessa-m/data/mariadb`).
  2. Runs `docker compose -f srcs/docker-compose.yaml up -d --build`. This reads the `docker-compose.yaml` file, builds all the custom images from their respective `Dockerfile`s, creates the isolated network (`inception`), creates the volumes, and starts all containers in the background (`-d`).

* **`make down`**
  1. Gracefully stops the containers without destroying the images or the persistent volumes. Use this if you need to tweak a configuration file or restart a service quickly.

* **`make clean`**
  1. Stops the containers (`make down`).
  2. Removes the created Docker images.
  3. Deletes the Docker network.
  *(This does **not** delete your volumes/database data. It's safe to use if you need to force a rebuild of a `Dockerfile`.)*

* **`make fclean` (The Nuclear Option)**
  1. Runs `make clean`.
  2. Forcibly removes **ALL** unused Docker images, containers, networks, and (most importantly) **VOLUMES** on the host machine. 
  3. Deletes the data directories created in `/home/abessa-m/data`. Use this only if you want to completely destroy the database and website and start over from zero.

* **`make re`**
  1. Runs `fclean`, then `all`. A complete scorched-earth rebuild.

---

## Managing Containers and Volumes (Relevant Commands)

If the Makefile isn't giving you enough control, you'll need to use the Docker CLI directly. Here are the essential spells.

### Logs and Debugging
* **View all running containers:**
  ```bash
  docker ps
  ```
  *(Or check the `docker-compose` specific list: `docker compose -f srcs/docker-compose.yaml ps`)*

* **Read the logs of a specific service:**
  If WordPress is crashing on startup, you need to see why:
  ```bash
  docker compose -f srcs/docker-compose.yaml logs -f wordpress
  ```
  *(The `-f` flag means "follow", so it streams the logs live.)*

* **Execute a shell inside a running container:**
  Sometimes you need to peek inside the box to see what's wrong:
  ```bash
  docker exec -it mariadb sh
  ```
  *(Note: Since we use Alpine Linux, use `sh`, not `bash`.)*

### Volumes and Persistence
* **List all volumes:**
  ```bash
  docker volume ls
  ```
* **Inspect a volume:**
  To see exactly where Docker thinks your WordPress files are stored on the host:
  ```bash
  docker volume inspect inception_wordpress
  ```

---

## Where Data is Stored and How it Persists

This project uses Docker Volumes to ensure that if a container crashes, is stopped, or is completely destroyed, the data survives.

### The Two Sacred Volumes
1. **`mariadb`:** Stores the raw database files (`/var/lib/mysql` inside the container).
2. **`wordpress`:** Stores the PHP files, themes, plugins, and uploaded media (`/var/www/html` inside the container).

### How Persistence Works
We do not use standard named volumes (which Docker hides away in `/var/lib/docker/volumes/`). Instead, the subject requires us to map the volumes to a specific path on the host machine, defined by the `DATA_PATH` environment variable.

In the `docker-compose.yaml`, we define the volumes like this:
```yaml
volumes:
  wordpress:
    driver: local
    driver_opts:
      type: none
      o: bind
      device: ${DATA_PATH}/wordpress
```

This tells Docker: "When the WordPress container writes to `/var/www/html`, actually write those files directly to `/home/abessa-m/data/wordpress` on the host machine."

Because the data lives on the host, you can completely destroy the Docker images and containers (`make clean`), rebuild them, and the new containers will simply reattach to the existing data on the host, resuming exactly where they left off.
