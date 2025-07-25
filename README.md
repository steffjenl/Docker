# Docker Cachet

A Docker setup for [Cachet](https://cachethq.io/) - an open-source status page system built with Laravel.

## Overview

This repository provides a complete Docker setup for running Cachet with the following components:
- **Cachet Application** - The main web application
- **Queue Worker** - Handles background jobs
- **Scheduler Worker** - Manages scheduled tasks
- **MariaDB Database** - Database backend

## Architecture Rationale
This architecture uses Docker to encapsulate all components of the Cachet application, ensuring easy deployment and management. Each service runs in its own container, allowing for isolation and scalability. The use of Docker Compose simplifies the orchestration of these services, making it easy to start, stop, and manage the entire application stack.
- **Isolation:** Each service runs independently, reducing the risk of one affecting the others.
- **Scalability:** You can scale workers and webservers separately based on workload.
- **Resource Management:** Allocate resources (CPU, memory) per container for better performance.
- **Resilience:** If one container fails (e.g., a worker), others remain unaffected and can restart automatically.
- **Simplified Maintenance:** Easier to update, debug, or restart individual components without downtime for the whole system.

## Prerequisites

Before you begin, ensure you have the following installed on your system:
- [Docker](https://docs.docker.com/get-docker/) (v20.10 or higher)
- [Docker Compose](https://docs.docker.com/compose/install/) (v2.0 or higher)
- Git (for cloning the repository)

## Quick Start

### 1. Clone the Repository

```bash
git clone https://github.com/steffjenl/docker-cachet.git
cd docker-cachet
```

### 2. Configure Environment Variables

Copy the example environment file and customize it:

```bash
cp .env.example .env
```

Edit the `.env` file and update the following required variables:

```bash
# Application settings
APP_NAME=YourStatusPage
APP_URL=http://localhost:8080
APP_KEY=                    # Will be generated automatically

# Database settings
DB_PASSWORD=your_secure_password_here

# Mail settings (optional but recommended)
MAIL_MAILER=smtp
MAIL_HOST=your.smtp.host
MAIL_PORT=587
MAIL_USERNAME=your_email@domain.com
MAIL_PASSWORD=your_email_password
MAIL_FROM_ADDRESS=noreply@yourdomain.com
MAIL_FROM_NAME="${APP_NAME}"
```

### 3. Start the Services

```bash
docker-compose up -d
```

This will start all services in the background:
- Cachet web application on port 8080
- MariaDB database
- Queue worker for background jobs
- Scheduler worker for automated tasks

### 4. Generate Application Key

After the containers are running, generate the Laravel application key and copy it to your `.env` file:

```bash
docker exec cachet-app php artisan key:generate --show
```

### 5. Run Database Migrations

Set up the database tables:

```bash
docker exec cachet-app php artisan migrate --force
```

### 6. Create the first user

Create the first user by following the prompts:

```bash
docker exec -it cachet-app php artisan cachet:make:user
```

### 7. Access Your Status Page

Open your web browser and navigate to:
```
http://localhost:8080
```

Follow the setup wizard to complete the installation.

## Configuration

### Environment Variables

The `.env` file contains all configuration options. Key variables include:

| Variable | Description | Default |
|----------|-------------|---------|
| `APP_NAME` | Your status page name | Cachet |
| `APP_URL` | Base URL for your installation | http://localhost |
| `APP_DEBUG` | Enable debug mode (set to false in production) | false |
| `DB_PASSWORD` | Database password | ExamplePassword!2020! |
| `MAIL_MAILER` | Mail driver (smtp, log, etc.) | log |

### Port Configuration

By default, the application runs on port 8080. To change this, edit the `docker-compose.yml` file:

```yaml
ports:
  - "YOUR_PORT:80"
```

### Custom Domain

To use a custom domain:

1. Update `APP_URL` in your `.env` file
2. Configure your web server/reverse proxy to forward requests to the Docker container
3. Ensure SSL/TLS certificates are properly configured if using HTTPS

## Production Deployment

### Security Considerations

1. **Change default passwords**: Update `DB_PASSWORD` in your `.env` file
2. **Use HTTPS**: Configure SSL/TLS certificates
3. **Secure database**: Restrict database access and use strong passwords
4. **Environment variables**: Keep your `.env` file secure and never commit it to version control
5. **Updates**: Regularly update the Docker images

### Reverse Proxy Setup (Nginx Example)

```nginx
server {
    listen 80;
    server_name status.yourdomain.com;
    
    location / {
        proxy_pass http://localhost:8080;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

## Maintenance

### Updating

To update to the latest version:

```bash
docker-compose pull
docker-compose up -d
```

### Backup

#### Database Backup
```bash
docker exec cachet-mariadb mysqldump -u root -p cachet > backup_$(date +%Y%m%d_%H%M%S).sql
```

#### Restore Database
```bash
docker exec -i cachet-mariadb mysql -u root -p cachet < backup_file.sql
```

### Logs

View application logs:
```bash
docker-compose logs -f cachet-app
```

View all service logs:
```bash
docker-compose logs -f
```

## Troubleshooting

### Common Issues

1. **Permission errors**: Ensure Docker has proper permissions
2. **Port conflicts**: Make sure port 8080 isn't already in use
3. **Database connection issues**: Verify database credentials in `.env`

### Reset Installation

To start fresh:

```bash
docker-compose down -v
docker-compose up -d
```

**Warning**: This will delete all data including your database.

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

## Support

- [Cachet Documentation](https://docs.cachethq.io/)
- [GitHub Issues](https://github.com/steffjenl/docker-cachet/issues)
- [Docker Documentation](https://docs.docker.com/)

## License

This project is licensed under the MIT License. See the [Cachet license](https://github.com/cachethq/cachet/blob/3.x/LICENSE) for details.


