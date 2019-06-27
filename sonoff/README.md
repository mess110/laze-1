# sonoff

Control [sonoff slampher](https://www.itead.cc/slampher.html)
(and maybe other sonoff devices) from the terminal.

## Setup

```
virtualenv -p python3 venv
source venv/bin/activate
pip install -r requirements.txt
./lights.py help
```

## Accessing the script from any folder

Add `lumina` to path and make sure you set `$LAZE_PATH` to the location of
`laze-1` repo. See [README.md](/README.md) for more info.

## Periodic lights

You can setup crontab to control the lights periodically by appending to
`crontab -e`:

```
# turn off all lights at midnight
0 0 * * * lumina sleep:off

# turn on living room lights at 7pm
0 19 * * * lumina living:on
```
