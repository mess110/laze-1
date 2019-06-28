# api

Simple http/https server which can issue terminal commands

## setup

Authentitaion is based on a secret token. Don't share it with anybody and use
https.

```
TOKEN=secret node api.js
```

## https

```
HTTPS=1 KEY_PATH=... CERT_PATH=... PORT=443 TOKEN=secret node api.js
```

## cli

```
./cli
./cli /?cmd=whoami
./scli /?cmd=whoami // for https
```

## Auto start the service

Move `api.service` to `/etc/systemd/system/api.service`
