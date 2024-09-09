
# Dockerized Laravel + PostgreSQL

Simple dockerized Laravel app



## Installation

To begin installation **Docker and Docker-compose are required**

copy the **.env.example** file and change the name file to **.env**

then you need to generate an **APP_KEY**, to do this if you have php >8.1 in the proyect folder you can run this command: 
```bash
  php artisan key:generate
```
or you can uncomment the RUN command at the end of the **Dockerfile**

then you can run the docker command: 
```bash
docker-compose up --build -d
```
    
