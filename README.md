# Docker Moodle environment

#### notes
  - xdebug is disabled by default
  - there's no database container; use another
    - `extra_hosts` in `docker-compose.yml` should point to it

## Create a Moodle instance

1. create a project tree with moodle structure in ~/projects (eg. moodle35.test), and in there:
  - `git checkout` a moodle branch in folder `htdocs`
  - `mkdir moodledata`
2. checkout *this* repo in your docker folder (eg. `~/docker/moodle35`)
3. `cd ~/docker/moodle35` and copy `.env-dist` to `.env` and set `COMPOSE_PROJECT_NAME` (eg. moodle35)
4. `docker-compose up -d` builds and starts the Moodle environment
5. add `127.0.0.1 moodle35.test` in `/etc/htdocs`

## CRON

You can set the moodle cron _from your (linux) host_!

`* * * * * docker exec projectname_php-fpm php /var/www/html/admin/cli/cron.php > /dev/null`

where `projectname_php-fpm` is the name of your container. (check `docker ps`)

#### Important notes:

- use `crontab -e` as yourself, **NOT** with `sudo`
- any cron request will frustrate an xdebug session by making a new request. Before starting debug sessions STOP YOUR CRON!
