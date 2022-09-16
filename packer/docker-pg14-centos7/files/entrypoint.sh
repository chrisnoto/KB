#!/bin/sh

PGDATA="/var/lib/pgsql/14/data"
PGAUTOCONF=${PGDATA}/postgresql.auto.conf
PGDB=${PGDATABASE:-test}
PGUSERNAME=${PGUSERNAME:-test}
PGPASSWD=${PGPASSWORD:-vSTJ456}
PGADMPWD=${PGADMPWD:-vSTJ456}


pg_initdb()
{
initdb -D ${PGDATA} --data-checksums
}

pg_conf()
{
echo "host all all all md5" >> ${PGDATA}/pg_hba.conf
echo "listen_addresses = '*'" >> ${PGAUTOCONF}
echo "logging_collector = 'off'" >> ${PGAUTOCONF}
}

pg_prestart()
{
pg_ctl -D ${PGDATA} -w start
}

pg_stop()
{
pg_ctl -D ${PGDATA} -m fast -w stop
}

pg_sql()
{
/bin/psql -v ON_ERROR_STOP=1 --username postgres --dbname postgres <<-EOSQL
  create user ${PGUSERNAME} with login password '${PGPASSWD}';
  alter user postgres password '${PGADMPWD}';
  create database ${PGDB} with owner = ${PGUSERNAME};
  create extension if not exists "postgres_fdw";
EOSQL
}



_main() {
  if [ "${1:0:1}" = '-' ]; then
    set -- postgres "$@"
  fi

  if [ "$1" = 'postgres' ];then
    if [ -e "${PGDATA}/base" ];then
      echo "PostgreSQL appears to contain a database; Skipping initialization"
    else
      pg_initdb
      pg_conf
      pg_prestart
      pg_sql
      pg_stop
      echo "PostgreSQL init process complete; Ready for start up"
    fi
  fi
  exec "$@"
}

_main "$@"

