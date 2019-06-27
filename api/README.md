# api

Simple http server which can issue terminal commands

## setup

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
```

## Auto start the service

Move `api.service` to `/etc/systemd/system/api.service`
