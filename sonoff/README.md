# lights-sonoff

Control [sonoff slampher](https://www.itead.cc/slampher.html)
(and maybe other sonoff devices) from the terminal.

This is a wrapper around [sonoff python](https://github.com/lucien2k/sonoff-python/)

## Setup

```
virtualenv -p python3 venv
source venv/bin/activate
pip install -r requirements.txt
./lumina
```

## Security

The user and password for the account is never stored, instead the scripts
store a key and secret.

## Accessing the script from any folder

Add `lumina` to path and make sure you set `$LIGHTS_SONOFF_PATH` to the
location of `lights-sonoff` repo.

```
LIGHTS_SONOFF_PATH="$HOME/lights-sonoff"
```

## Periodic lights

You can setup crontab to control the lights periodically by appending to
`crontab -e`:

```
# turn off all lights at midnight
0 0 * * * /path/to/lumina sleep:off

# 0 0 * * * /path/to/lumina sleep:off > /path/to/log.log 2>&1


# turn on living room lights at 7pm
0 19 * * * /path/to/lumina living:on
```
