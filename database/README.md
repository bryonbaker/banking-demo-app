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