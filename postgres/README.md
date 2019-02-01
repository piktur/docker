# PostgreSQL

Cloned from [docker-library/postgres](https://github.com/docker-library/postgres)

## Build

> **TLDR;** Don't fuck around with version disparity; `pg_dump --format plain --compress 5 ...`.
> Or use [piktur/postgres](https://github.com/piktur/postgres/tree/build-from-source)

You'll have to build from source if require an exact version. To do that means you'll have to [clone](https://github.com/docker-library/postgres) and modify the [Dockerfile](https://github.com/docker-library/postgres/blob/f8bfec9c70f06c5fb9815653732c5d976f6f3c36/9.4/Dockerfile).

* Overload [`PG_VERSION`](https://github.com/docker-library/postgres/blob/master/9.4/Dockerfile#L74) and
* Remove [L81-L88](https://github.com/docker-library/postgres/blob/f8bfec9c70f06c5fb9815653732c5d976f6f3c36/9.4/Dockerfile#L81-L88) and [L136](https://github.com/docker-library/postgres/blob/f8bfec9c70f06c5fb9815653732c5d976f6f3c36/9.4/Dockerfile#L136)

Which also means you'll have to deal with flaky GPG key servers. [Circumvent failure on GPG Key request](https://github.com/bodastage/bts-ce-database/issues/1), one of them is bound to respond.

```bash
  for server in ha.pool.sks-keyservers.net \
                hkp://p80.pool.sks-keyservers.net:80 \
                keyserver.ubuntu.com \
                hkp://keyserver.ubuntu.com:80 \
                pgp.mit.edu; \
  do \
    gpg --batch --keyserver "$server" --recv-keys "$key" && break || echo "Trying new server..."; \
  done;
```

## Ingest

Non-SQL backups (`custom|directory`) generated with a different version of `pg_dump` than that of the target database cannot be ingested; use `--format plain --compress 5` to circumvent the issue.

## Database Configuration

Use `POSTGRES_INITDB_ARGS` to amongst other things, `--add-host` they will be passed on to `initdb`.

## Troubleshoot

* If postgres service running on the host machince you may need to stop it. To do so:

  ```sh
  pg_ctl -D /usr/local/var/postgres stop -s -m fast

  brew services stop postgresql # for macOS users
  ```

  To start it again

  ```sh
  pg_ctl -D /usr/local/var/postgres -l /usr/local/var/postgres/server.log start

  brew services start postgresql # for macOS users
  ```
