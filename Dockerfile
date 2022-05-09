FROM postgres:14.2

# --------------------
# install timescaledb
# --------------------
ENV TIMESCALEDB_VERSION 2.6.1
RUN timescaledbDependencies="git \
    cmake \
    ca-certificates \
    build-essential \
    postgresql-server-dev-$PG_MAJOR \
    libssl-dev \ 
    libkrb5-dev" \
    && apt-get update \
    && apt-get install -y --no-install-recommends ${timescaledbDependencies} \
    && cd /tmp \
    && git clone https://github.com/timescale/timescaledb.git \
    && cd timescaledb \
    && git checkout tags/$TIMESCALEDB_VERSION \
    && ./bootstrap -DREGRESS_CHECKS=OFF \
    && cd build && make \
    && make install \
    && apt-get clean \
    && apt-get remove -y ${timescaledbDependencies} \
    && apt-get autoremove -y \
    && rm -rf /tmp/timescaledb /var/lib/apt/lists/* /var/tmp/*

# --------------------
# install pglogical
# --------------------
RUN apt install postgresql-common -y
RUN sh /usr/share/postgresql-common/pgdg/apt.postgresql.org.sh -y
RUN apt-get install postgresql-14-pglogical 

# --------------------
# install postgis
# --------------------
ENV POSTGIS_MAJOR 3
RUN apt-get update \
      && apt-cache showpkg postgresql-$PG_MAJOR-postgis-$POSTGIS_MAJOR \
      && apt-get install -y --no-install-recommends \
          postgresql-$PG_MAJOR-postgis-$POSTGIS_MAJOR \
          postgresql-$PG_MAJOR-postgis-$POSTGIS_MAJOR-scripts \
      && rm -rf /var/lib/apt/lists/* /var/tmp/*

# --------------------
# install pgtap
# --------------------
ENV PGTAP_VERSION=v1.2.0
RUN pgtapDependencies="git \
    ca-certificates \
    build-essential" \
    && apt-get update \
    && apt-get install -y --no-install-recommends ${pgtapDependencies} \
    && cd /tmp \
    && git clone https://github.com/theory/pgtap.git \
    && cd pgtap \
    && git checkout tags/$PGTAP_VERSION \
    && make install \
    && apt-get clean \
    && apt-get remove -y ${pgtapDependencies} \
    && apt-get autoremove -y \
    && rm -rf /tmp/pgtap /var/lib/apt/lists/* /var/tmp/*

# --------------------
# install pgAudit
# --------------------
ENV PGAUDIT_VERSION=1.6.2
RUN pgAuditDependencies="git \
    ca-certificates \
    build-essential \
    postgresql-server-dev-$PG_MAJOR \
    libssl-dev \
    libkrb5-dev" \
    && apt-get update \
    && apt-get install -y --no-install-recommends ${pgAuditDependencies} \
    && cd /tmp \
    && git clone https://github.com/pgaudit/pgaudit.git \
    && cd pgaudit \
    && git checkout ${PGAUDIT_VERSION} \ 
    && make check USE_PGXS=1 \
    && make install USE_PGXS=1 \
    && apt-get clean \
    && apt-get remove -y ${pgAuditDependencies} \
    && apt-get autoremove -y \
    && rm -rf /tmp/pgaudit /var/lib/apt/lists/* /var/tmp/*

# --------------------
# install plpgsql_check
# --------------------
ENV PLPGSQL_CHECK_VERSION=v2.1.5
RUN plpgsqlCheckDependencies="git \
    ca-certificates \
    build-essential \
    postgresql-server-dev-$PG_MAJOR" \
    && plpgsqlCheckRuntimeDependencies="libicu-dev" \
    && apt-get update \
    && apt-get install -y --no-install-recommends ${plpgsqlCheckDependencies} ${plpgsqlCheckRuntimeDependencies} \
    && cd /tmp \
    && git clone https://github.com/okbob/plpgsql_check.git \
    && cd plpgsql_check \
    && git checkout ${PLPGSQL_CHECK_VERSION} \
    && make clean \ 
    && make install \
    && apt-get clean \
    && apt-get remove -y ${pgsqlHttpDependencies} \
    && apt-get autoremove -y \
    && rm -rf /tmp/plpgsql_check /var/lib/apt/lists/* /var/tmp/*

# --------------------
# language
# --------------------
ENV LANGUAGE=en_US.UTF-8
ENV LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8

# --------------------
# entrypoint
# --------------------
RUN mkdir -p /docker-entrypoint-initdb.d
ADD mnt /docker-entrypoint-initdb.d/