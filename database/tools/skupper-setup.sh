#! /bin/bash

skupper gateway delete
skupper delete
rm -rf ~/.local/share/skupper/

skupper init --site-name local --enable-flow-collector --enable-console --console-user admin --console-password password
watch oc get pods

skupper expose deployment banking-database --port 5432

skupper gateway init --type podman

skupper network status

skupper gateway forward banking-database 5432

skupper gateway status