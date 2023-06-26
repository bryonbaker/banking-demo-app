#! /bin/bash

#
# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License
#

# Note: These passwords need to match the kubernetes secrets for the database.
ADMIN_EMAIL=admin@demo.net
ADMIN_PWD=demoadminuser
PGADMIN_PORT=8089
PGSQL_USER=demouser
PGSQL_PASSWORD=demopassword
PGSQL_DB=banking-demo-db

# Check that one of Podman or Docker is installed.
echo "Checking for container runtime..."
runtime=$(which podman)
inst_status=$?
if [ $inst_status -eq 0 ]; then
   echo "Podman is installed"
   CONTAINER_RUNTIME="podman"
else
  runtime=$(which docker)
  inst_status=$?
  if [ $inst_status -eq 0 ]; then
    echo "Docker is installed"
    CONTAINER_RUNTIME="docker"
   else
      echo "ERROR: No container runtime found."
      exit
   fi
fi

echo "Starting pgadmin4"
$CONTAINER_RUNTIME run -d --rm --name pgadmin4 -p $PGADMIN_PORT:80 -e PGADMIN_DEFAULT_PASSWORD=$ADMIN_PWD -e PGADMIN_DEFAULT_EMAIL=$ADMIN_EMAIL docker.io/dpage/pgadmin4:6.11

echo "Waiting for the database to start"
exec 2>/dev/null     # Suppress stderr while we wait
RESP=0
until [ $RESP -eq 52 ]
do
   sleep 2
   printf '.'
   curl localhost:5432
   RESP=$?
done
exec 2>/dev/tty    # Restore stderr output.

echo
echo "Database connection details:"
echo "============================"
echo "Database server url is: " $HOSTNAME
echo "Database connection port: 5432"
echo "Database database: " $PGSQL_DB
echo "Database user: " $PGSQL_USER
echo "Database password: " $PGSQL_PASSWORD
echo "To test the database has been initialised run the following query in pgadmin4:"
echo "select * from work"

