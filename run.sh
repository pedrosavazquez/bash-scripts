cd docker
docker build -t cron_container .
docker run -d cron_container
