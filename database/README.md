# Setup
First you need to install the image pull secret:

`
oc create -f <secret name> --namespace=NAMESPACEHERE
`

Instructions for obtaining the secret are found here: https://access.redhat.com/terms-based-registry/

## Creating the database secrets
`echo -n "demo-user" | base64 -w 0`

`echo -n "demo-password" | base64 -w 0`

`echo -n "demo-adminuser" | base64 -w 0`

Paste the sectrets into the secret yaml file.

# Testing external access to the database with Red Hat Service Interconnect

Install RHSI
`
skupper init --site-name local --enable-flow-collector --enable-console --console-user admin --console-password password
`

Then expose the deployment: `skupper expose deployment banking-database --port 5432`

Initialise the gateway: `skupper gateway init --type podman`

Make the database available off-cluster: `skupper gateway forward banking-database 5432`


