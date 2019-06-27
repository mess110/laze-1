# girbot

[girbot](https://github.com/mess110/girbot) is used to simulate the actions
of a user on different merchants. Merchants can be mobile phone bills,
utility bills etc.

## Running from sh

Runs in a docker container

```
plata electrica
```

## Running on host

Ruby version 2.4.3

```
gem install girbot
```

```
ruby girbot.rb --run plata_electrica

// with visible gui (used for debugging)
ruby girbot.rb --ui --run plata_electrica
```

## Accessing the script from any folder

Add `plata` to path and make sure you set `$LAZE_PATH` to the location of
`laze-1` repo. See [README.md](/README.md) for more info.
