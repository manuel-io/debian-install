#!/bin/sh
# DATABASE SOFTWARE

# DATABASE TOOLS
f "Install Database Tools?" &&
  apt-get install -y sqlite3 \
                     libsqlite3-dev \
                     postgresql-client

#  POSTGRESQL SERVER
f "Install PostgreSQL Server?" && {
  apt-get install -y postgresql
} && {
  # settings
  systemctl stop postgresql
  systemctl disable postgresql
}
