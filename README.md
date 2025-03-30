# 🐧 Ubuntu Dev Container with Essential Services

A flexible and customizable Ubuntu-based Docker container with pre-installed essential tools and services like SSH, Apache, MySQL, PostgreSQL, Python, and more. Ideal for development, pentesting labs, and lightweight server setups.

---

## 📦 Included Services & Tools

This container includes the following tools and services:

### 🔧 Core Utilities
- `vim`, `nano`, `curl`, `wget`, `git`, `htop`, `tree`, `unzip`, `tar`, `less`
- `sudo`, `build-essential`, `software-properties-common`
- `iputils-ping`, `net-tools`, `gnupg`, `ca-certificates`

### 🐍 Programming Languages
- Python 3
- pip3 (Python package installer)

### 🌐 Networking & Servers
- **OpenSSH Server** – Secure shell access
- **Apache2** – Web server (optional via env var)
- **Nginx** – Web server (optional)
- **MySQL Server**
- **PostgreSQL Server**

---

## 🛠️ How to Build the Docker Image

```bash
docker build -t ubuntu-dev-container .
```

This command builds the Docker image using the provided `Dockerfile`.

---

## 🚀 How to Run the Container

You can run the container with environment variables and port bindings as shown:

```bash
docker run -d \
  -e SSH_PUBLIC_KEY="$(cat ~/.ssh/id_rsa.pub)" \
  -e APACHE_ENABLE=true \
  -e TZ="Asia/Kolkata" \
  -p 2222:22 -p 80:80 -p 443:443 -p 3306:3306 -p 5432:5432 \
  --name dev-container \
  ubuntu-dev-container
```

> 📌 **Note:** Replace `~/.ssh/id_rsa.pub` with the actual path to your SSH public key.

---

## 🔐 SSH Access (Recommended)

1. Ensure you have SSH public key ready (usually in `~/.ssh/id_rsa.pub`)
2. Run the container as shown above with the `SSH_PUBLIC_KEY` environment variable
3. Access the container via:

```bash
ssh -p 2222 ghost@localhost
```

> Default username: `ghost`  
> Password login is disabled for security. Only key-based SSH is allowed.

---

## 🌐 Apache & Web Services

If you enable Apache via `APACHE_ENABLE=true`, you can access the web server at:

```
http://localhost:80
```

You can place files inside the container at `/var/www/html` or mount your custom folder with:

```bash
-v /your/local/html:/var/www/html
```

---

## 📁 Entry Point Script

The container uses `entrypoint.sh` to:
- Inject your SSH public key
- Start Apache if enabled
- Launch SSH in daemon mode

---

## 🧪 Health Check

The container includes a basic `HEALTHCHECK` to ensure SSH is responsive every 30 seconds.

---

## ⚙️ Example: Docker Compose (Optional)

Here’s a basic `docker-compose.yml` (if you want one):

```yaml
version: '3.8'
services:
  ubuntu-dev:
    build: .
    container_name: dev-container
    ports:
      - "2222:22"
      - "80:80"
      - "443:443"
      - "3306:3306"
      - "5432:5432"
    environment:
      SSH_PUBLIC_KEY: ${SSH_PUBLIC_KEY}
      APACHE_ENABLE: true
      TZ: Asia/Kolkata
    volumes:
      - ~/.ssh/id_rsa.pub:/home/ghost/.ssh/authorized_keys
```

---

## 🧼 Cleanup

To stop and remove the container:

```bash
docker stop dev-container && docker rm dev-container
```

To remove the image:

```bash
docker rmi ubuntu-dev-container
```

---
> 🔒 Always be cautious with exposed services in production. This container is built primarily for local or secure lab environments.
```
