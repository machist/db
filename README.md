# db

PostgreSQL with some plugins.

## features

- ✅ [pg](https://www.postgresql.org/)
- ✅ [pg-logical](https://github.com/2ndQuadrant/pglogical)
- ✅ [pg-wal](https://www.postgresql.org/docs/current/runtime-config-wal.html) = logical and [max_replication_slots](https://www.postgresql.org/docs/current/runtime-config-replication.html) = 5
- ✅ [pg-gis](https://postgis.net/)
- ✅ [pg-tap](https://pgtap.org/)
- ✅ [pg-audit](https://www.pgaudit.org/)
- ✅ [pg-check](https://github.com/okbob/plpgsql_check)
- ✅ [timescaledb](https://github.com/timescale/timescaledb)

## docker
````bash
# build
docker build -t ghcr.io/machist/db:latest .
docker push ghcr.io/machist/db:latest

# sample
docker run --rm -d \
  --name machist-db \
  -p 5432:5432 \
  -e POSTGRES_PASSWORD=postgres \
  ghcr.io/machist/db:latest:latest
````

## database (sample)
````bash
docker exec -it machist-db bash
psql -U postgres 

CREATE DATABASE machist;
CREATE USER machist WITH PASSWORD 'machist';
GRANT ALL PRIVILEGES ON DATABASE machist to machist;
````

## extensions (sample)
````bash
docker exec -it machist-db bash
psql -U postgres -d machist
````

### postgis
````bash
-- Install
CREATE EXTENSION postgis;

-- Check if PostGIS is indeed installed
select postgis_full_version();
````

### pgtap
````bash
-- Install
CREATE EXTENSION pgtap;

-- Check if pgtap is indeed installed
select pgtap_version();
````

### timescaledb
````bash
CREATE EXTENSION timescaledb;
````

### pglogical
````bash
CREATE EXTENSION pglogical;
````