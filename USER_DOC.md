<!--*************************************************************************-->
<!--                                        ::::::::    ::::::::   ::::::::: -->
<!-- USER_DOC.md                          :+:    :+:  :+:    :+:  :+:        -->
<!--                                           +:+         :+:   :+:         -->
<!-- github.com/d-branco                    +#+         +#+      +#+#+#+     -->
<!--                                     +#+         +#+              +#+    -->
<!-- Created: 2026/02/23 14:14:49      #+#         #+#      +#+        #+#   -->
<!-- Updated: 2026/02/23 14:20:00     #########  #########  ###      ###     -->
<!--                                                          ########       -->
<!--*************************************************************************-->

# USER_DOC.md: The Inception Matrix

Welcome to the **Inception** project! You are about to spin up a fully containerized infrastructure just to host a single WordPress blog. Is it overkill? Absolutely. Is it glorious? You bet.

This document is your survival guide to navigating the matrix of containers, understanding what services are running, how to start/stop the magic, and where to find the keys to the kingdom.

---

## Part 1: The Mandatory Infrastructure

These are the core services that keep the lights on and ensure you don't instantly fail your 42 evaluation.

### What's Actually Running in Here?

1.  **NGINX (The Bouncer):** The absolute only way into this network. It sits at `abessa-m.42.fr` on port `443` (HTTPS) and strictly enforces TLSv1.2 or TLSv1.3. If you don't have a secure connection, you're not getting in.
2.  **WordPress & PHP-FPM (The Brains):** The actual website. It runs PHP-FPM to process requests and serves the content. It does not contain NGINX.
3.  **MariaDB (The Memory):** The database. It stores all the WordPress posts, users, and comments. It's completely isolated and only talks to WordPress.

### How to Start and Stop the Magic

Everything is orchestrated via the root `Makefile`. You don't need to manually type long `docker compose` commands unless you really want to impress the evaluator.

*   **Power Up:** `make` or `make up`
    *   *What it does:* Builds the Docker images, creates the necessary directories in your host's `DATA_PATH` (e.g., `/home/abessa-m/data`), adds the domain to your `/etc/hosts`, and summons the infrastructure in detached mode.
*   **Take a Nap:** `make stop`
    *   *What it does:* Gracefully stops the containers without destroying your data.
*   **Burn it Down:** `make clean` or `make fclean`
    *   *What it does:* Stops and removes the containers. `fclean` also nukes the images and volumes. Your host data directory might survive, but the Docker state is reset.
*   **The Nuclear Option:** `make oblivion`
    *   *What it does:* "Oblivion achieved." It destroys all containers, prunes your entire Docker system, and forcefully deletes your `DATA_PATH` directory. Use this only when you want to watch the world burn and start from absolute zero.

### Accessing the Websites and Dashboards

Once you've run `make up`, you can access the fruits of your labor.

*   **Main WordPress Site:** [https://abessa-m.42.fr](https://abessa-m.42.fr)
    *   **Admin Panel:** [https://abessa-m.42.fr/wp-login.php](https://abessa-m.42.fr/wp-login.php)

### Locating and Managing Credentials

All passwords, database names, and sensitive setup variables are safely locked away in the `srcs/.env` file.

*   **The Golden Rule:** Never, *ever* commit the `.env` file to Git. Doing so is an instant evaluation failure. 
*   **Changing Credentials:** If you want to change passwords or database names, you must edit the `srcs/.env` file. However, because the database is initialized on the *first* run, simply restarting the containers won't update existing data. You will need to run `make oblivion` (to wipe the old database volume) and then `make up` to re-initialize everything with the new secrets.

### Checking Services are Running Correctly

*   **The Easy Way:** Run `make status`. This cleanly prints all your running containers, images, volumes, and networks.
*   **The Hacker Way:** Verify that NGINX is actually enforcing TLS correctly:
    ```bash
    openssl s_client -connect abessa-m.42.fr:443 | grep rotocol
    ```

---

## 🚀 Part 2: The Bonus Realm

Because just doing the mandatory part isn't fun enough. Here are the extra services running in the background.

### What Else is Running?

1.  **Redis (The Caffeine):** An in-memory cache for WordPress. It makes the site significantly faster by remembering recent database queries.
2.  **Adminer (The Telescope):** A lightweight, web-based database management tool (like phpMyAdmin, but better).
3.  **FTP Server (The Smuggler):** Allows you to transfer files directly to the WordPress volume using an FTP client.
4.  **Static Website (The Side Quest):** A completely separate, simple HTML website running on its own port.
5.  **Dozzle (The All-Seeing Eye):** A beautiful, real-time log viewer for all your Docker containers.

### Accessing the Bonus Goodies

*   **Adminer:** [http://localhost:8084](http://localhost:8084)
*   **Static Website:** [http://localhost:225](http://localhost:225) (A nice quiet place away from PHP).
*   **Dozzle (Logs):** [http://localhost:8085](http://localhost:8085) (Watch your containers complain in real-time).

### Pro-Tips & Diagnostics for Bonuses

*   **The Ultimate Check:** Run `make bonus`. This script performs a curl/ping check across Redis, FTP, the Static site, Adminer, and Dozzle, printing highly satisfying `[OK]` messages if everything is alive.
*   **FTP Shenanigans:** The `Makefile` includes commands for the FTP service:
    *   `make ftp_export`: Downloads a backup of your WordPress site to `./wp_backup/` via FTP.
    *   `make ftp_import`: Restores the backup from `./wp_backup/` to the server.
*   **Poking MariaDB Manually:** If you want to bypass Adminer and feel like a true sysadmin, you can hop directly into the database container:
    ```bash
    docker exec -it mariadb mariadb -u faith -pthemirrorsedge shard
    ```
    *Fun commands to try once inside:*
    *   `SHOW TABLES;`
    *   `SELECT * FROM wp_comments;`
    *   `SELECT comment_content FROM wp_comments;`
    *   `quit;` (to exit)
