---
title: "TLS Encryption"
linkTitle: "TLS Encryption"
weight: 9
description: >
  This guide covers how you can enable TLS transport encryption.
---

Open Match API is served in HTTP and gRPC. By default, these are served
over unencrypted channels which is not good for security posture. Open Match
provides support for TLS transport mode.

## Certificates

Before we can enable TLS transport mode we'll need to generate
certificate-private key pairs. These files will contain the encryption keys
used to secure communication between each server.

### Certgen

*Certgen uses the golang tls library and has not been reviewed by a security*
*expert. Use at your own risk.*

Open Match provides a certgen tool for your convience to generate certificates.
This tool is used to generate the TLS certificates for development and may
be used to quickly configure a secure cluster while waiting for your final
certificates.

```bash
# Create Root-CA directory.
mkdir -p secrets/tls/root-ca

# Generate Root-CA public certificate-private key pair.
./certgen -ca=true -publiccertificate=secrets/tls/root-ca/public.cert -privatekey=secrets/tls/root-ca/private.key

# Create Server Keys directory.
mkdir -p secrets/tls/server/

# Create server public certificate-private key pair derived from the Root-CA keys.
./certgen -publiccertificate=secrets/tls/server/public.cert -privatekey=secrets/tls/server/private.key -rootpubliccertificate=secrets/tls/root-ca/public.cert -rootprivatekey=secrets/tls/root-ca/private.key
```

The instructions above only generate 1 server key for all servers. For 1 key
per server follow the OpenSSL instructions below.

### OpenSSL

OpenSSL is a popular library to support SSL/TLS. We'll be using the tool
OpenSSL ships with the generate public certificate-private key pairs for each
Open Match server you run.

The steps below will do the following:

  1. Create a self-signed certificate authority. Basically this is the root key.
    The public key will be trusted by all servers and clients and the private
    key must be stored securely somewhere, it's only used to generate derived
    keys. A compromise of the root private key compromises the whole Open Match
    cluster.
  1. Create self-signed public certificate-private key pair for each server
     {om-frontend, om-backend, etc...}. A compromise of this private key
     will only compromise that particular server.
  1. Enable TLS mode on Open Match servers.
  1. Mount the TLS certificate for the Open Match server.

```bash
# Create a Root-CA (Certificate Authority) private key.
# This will prompt for a password.
# This key will only be used for generating derived public certificate-private key pairs.
# DO NOT USE on a server.
openssl genrsa -des3 -out rootCA.key 4096

# Generate the Root-CA public certificate. This is the "trusted certificate"
# that each client and server needs to know about so they can trust traffic
# from each other.
openssl req -x509 -subj "/C=US/ST=Open/L=Match/O=Open Match/OU=Match Making/CN=open-match.dev" -new -nodes -key rootCA.key -sha256 -days 1825 -out rootCA.cert

# Create a derived public certificate-private key pair
openssl req -new -sha256 -key om-frontend.key -subj "/C=US/ST=Open/L=Match/O=Open Match/OU=Frontend/CN=open-match.dev" -out om-frontend.cert

# The steps below are to generate a public certificate-private key pair for the
# om-frontend server. Repeat the following steps for each server. The address
# of the server is specified by the Common Name (CN) parameter.
#
# The list of servers you'll want to generate keys for are:
# om-backend:51505,om-demo:51507,om-demoevaluator:51508,om-demofunction:51502,om-e2eevaluator:51518,om-e2ematchfunction:51512,om-frontend:51504,om-mmlogic:51503,om-swaggerui:51500,om-synchronizer:51506

# Create a private key for the om-frontend server. (No password)
openssl genrsa -out om-frontend.key 4096

# Create a certificate signing request (CSR). This is basically a proposal to
# create a certificate based on the parameters you specify here.
openssl req -new -sha256 -key om-frontend.key -subj "/C=US/ST=Open/L=Match/O=Open Match/OU=Match Making/CN=om-frontend:51504" -out om-frontend.csr

# (optional) Verify that the CSR looks like you expected it to.
openssl req -in om-frontend.csr -noout -text

# Create the certificate for the frontend server based on the CSR just created.
# The certificate will be backed by the Root-CA you created in the first step.
openssl x509 -req -in om-frontend.csr -CA rootCA.cert -CAkey rootCA.key -CAcreateserial -out om-frontend.cert -days 1825 -sha256

# (optional) Verify that the om-frontend certificate looks like you expected
# it to.
openssl x509 -in om-frontend.cert -text -noout
```

*If the hostname does not match the server the client will report a hostname verification error.*

## Configuration

To enable TLS-mode you'll need to make the following changes:

**matchmaker_config.yaml**

```yaml
api:
  tls:
    certificatefile: '/app/secrets/tls/server/public.cert'
    privatekey: '/app/secrets/tls/server/private.key'
    rootcertificatefile: '/app/secrets/tls/rootca/public.cert'
    trustedCertificatePath: '/app/secrets/tls/rootca/public.cert'
```

Run these Kubernetes commands to install the secrets in your cluster:

```bash
# Create Secret for Root-CA
kubectl create secret generic om-tls-rootca --namespace open-match --from-file=secrets/tls/root-ca/public.cert
# Create Secret for Server certificate.
kubectl create secret generic om-frontend-tls --namespace open-match --from-file=secrets/tls/server/om-frontend.key --from-file=secrets/tls/server/om-frontend.cert
```

Add the following to your existing deployment for Frontend. *This is not a complete `Deployment` it only contains the TLS configuration.*

```yaml
kind: Deployment
metadata:
  name: om-frontend
spec:
  template:
    spec:
      volumes:
      - name: root-ca-volume
        secret:
          secretName: om-tls-rootca
      - name: tls-server-volume
        secret:
          # This may be different for each server based on how granular you want your keys.
          secretName: om-frontend-tls
      containers:
      - name: om-frontend
        volumeMounts:
        - name: om-config-volume
          mountPath: /app/config
        - name: root-ca-volume
          mountPath: /app/secrets/tls/rootca
        - name: tls-server-volume
          mountPath: /app/secrets/tls/server
```

## Limitations

* There may only be 1 trusted CA installed in an Open Match server.
  Each server may have it's own.
* The `om-swaggerui` and `om-demo` services do not support serving TLS but
  will communicate with other Open Match servers using TLS encryption
  if configured.
* Health checks and monitoring may not work. Prometheus supports TLS but
  the current Kubernetes configurations do not enable it at this time.
* Mixed TLS and unencrypted transport modes are not supported. If you're
  enabling TLS all servers must have it enabled.
