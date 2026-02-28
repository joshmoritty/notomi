# Notomi

## Local Development on Windows

### Prerequisites

Install the following before starting:

- **[Laravel Herd](https://herd.laravel.com/windows)** — provides PHP 8.4 and Composer in one installer. Alternatively, install PHP 8.4 and Composer manually.
- **[Node.js 20+](https://nodejs.org/)** — required for the Vite frontend toolchain.
- **[Docker Desktop](https://www.docker.com/products/docker-desktop/)** — used only to run MySQL. Your application code runs natively, not in Docker.

---

### 1. Clone and enter the repo

```powershell
git clone https://github.com/joshmoritty/notomi.git
cd notomi
```

### 2. Start MySQL

Docker is used only for the database. Start it with:

```powershell
docker compose up mysql -d
```

This starts a MySQL 8.4 container on port `3306` with:
- Root password: `secret`
- Database name: `laravel`

### 3. Configure your environment

```powershell
copy .env.example .env
```

Open `.env` and update the database section to match the container above:

```dotenv
DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=laravel
DB_USERNAME=root
DB_PASSWORD=secret
```

### 4. Install dependencies and set up the application

```powershell
composer run setup
```

This command will:
- Install PHP dependencies via Composer
- Generate the application key
- Run all database migrations
- Install Node.js dependencies
- Build frontend assets

### 5. Start the dev server

```powershell
composer run dev
```

This starts three processes concurrently:
- `php artisan serve` — the Laravel application at http://localhost:8000
- `npm run dev` — the Vite dev server with hot module replacement
- `php artisan queue:listen` — the background job queue worker

Changes to Blade templates, PHP files, and frontend assets will reflect in the browser immediately.

---

### Running tests

```powershell
composer run test
```

---

### Stopping MySQL

```powershell
docker compose down
```

To also delete the database volume (wipes all data):

```powershell
docker compose down -v
```

---

### With Docker Compose

Alternatively, you can start all services (app + MySQL) with:

```powershell
docker compose up -d
```

The app will be available at http://localhost:8080.

However, this has the drawback of running the app in a container, which can be slower on Windows. The above instructions run the app natively for better performance while still using Docker for MySQL.
