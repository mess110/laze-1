#!/usr/bin/env python3

import sys
import json

from api import Api
from config import Config, VERSION
from sonoff import SonoffException

config = Config()
config.read_config()
config.load_aliases()

def to_s(client):
    print("Light states:\n")
    results = client.info()
    for result in results:
        print("  %s - %s" % (result['name'].ljust(10), result['on']))

def to_json(client):
    results = client.info()
    print('[')
    for result in results:
        print("  %s," % json.dumps(result))
    print(']')


def help():
    print("""lumina (v%s)- sonoff remote control

Credentials are stored in ~/.sonoff-credentials , user/pass is not
stured, instead we store tokens.
Aliases can be found in ~/.sonoff-aliases and have the following format:

alias_1_name switch_1_name switch_2_name switch_3_name
alias_2_name switch_1_name switch_2_name

Example usage:

./lumina help
./lumina switch_name:off
./lumina switch_alias:on
./lumina info
./lumina json
""" % VERSION)


try:
    client = Api(config)
except SonoffException as e:
    print(e)
    sys.exit(1)

config.save_api_key_and_bearer(client.credentials())


if len(sys.argv) == 2:
    cmd = sys.argv[1]

    if cmd == 'info':
        to_s(client)
    elif cmd == 'json':
        to_json(client)
    elif cmd == 'help':
        help()
    else:
        vect2d = sys.argv[1].split(':')

        if len(vect2d) == 1:
            print("Error: wrong format, needs: switch_name:new_state (on/off)")
            sys.exit(1)

        target_light = vect2d[0]
        new_state = vect2d[1]

        if not new_state in ['on', 'off']:
            print("Error: wrong format, needs: switch_name:new_state (on/off)")
            sys.exit(2)

        target_devices = client.get_devices_by_alias(target_light)
        for device in client.get_devices_by_name(target_light):
            target_devices.append(device)

        for device in target_devices:
            client.cmd(device, new_state)
            print("%s is %s" % (device, client.is_on(device)))

else:
    help()
    to_s(client)
