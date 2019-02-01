# Docker Utils

1. [PostgreSQL](db/postgres/README.md)

## Environment Variables

Environment contains are defined for each environment. They are to be stored using this directory structure `config/docker/<service>/<environment>/.env`.

Some variables are required at **compile time**. `.env` files defined at `industrymoves/` will be overridden by those defined within nested directories.

`.env` **SHOULD** be kept out of source control, I am yet to decide upon the best approach to distributing them amongst the team.

## Useful Docker commands

> [**ANNIHILATE**](https://medium.com/the-code-review/clean-out-your-docker-images-containers-and-volumes-with-single-commands-b8e38253c271)
> `docker container stop $(docker container ls -a -q) 2> /dev/null; docker system prune -a -f`
>
> **!!CAUTION!! the following command will clear persistent storage ie. local databases**
> `docker container stop $(docker container ls -a -q) 2> /dev/null; docker system prune -a -f --volumes`

* List all containers `docker ps -a`

* Hook into STDOUT `docker attach <container ID/name>`

* Get the IP address of a running postgres container instance

    ```sh
    docker inspect --format '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' postgres-${PG_MAJOR:-9.4}
    ```

* Get the port of the running container instance (useful when `docker run -P` in which ports will be *published* randomly)

    ```sh
    docker port postgres-9.4 | grep -o "[0-9]*$"
    ```

* Once built, you should save the compiled image `docker save --output config/docker/db/postgres/$PG_MAJOR/postgres.tar`.
  To load it again, run `docker load --input config/docker/db/postgres/$PG_MAJOR/postgres.tar`
