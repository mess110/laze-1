#!/usr/bin/env python3

import sys
import json

from api import Api
from config import Config, VERSION
from sonoff import SonoffException

config = Config()
config.read_config()
config.load_aliases()


def print_json(obj):
    print(json.dumps(obj))


def to_s(client):
    print("Light status:\n")
    results = client.info()
    for result in results:
        print("  %s - %s" % (result['name'].ljust(10), result['on']))


def help():
    print("""lumina (v%s) - control lights from terminal

Read more: https://github.com/mess110/laze-1/tree/master/sonoff

Credentials are stored in ~/.sonoff-credentials , user/pass is not
stured, instead we store tokens.

Aliases can be found in ~/.sonoff-aliases and should have the fallowing format:

alias_1_name switch_1_name switch_2_name switch_3_name
alias_2_name switch_1_name switch_2_name

Example usage:

  lumina switch_name:off
  lumina switch_alias:on

  lumina json
""" % VERSION)


try:
    client = Api(config)
except SonoffException as e:
    print_json({'message': str(e)})
    sys.exit(1)

config.save_api_key_and_bearer(client.credentials())

if len(sys.argv) == 2:
    cmd = sys.argv[1]

    if cmd == 'json':
        info = client.info()
        print_json(info)
    else:
        vect2d = cmd.split(':')

        if len(vect2d) == 1:
            print_json({'message': "Error: wrong format, needs: switch_name:new_state (on/off)"})
            sys.exit(1)

        target_light = vect2d[0]
        new_state = vect2d[1]

        if not new_state in ['on', 'off']:
            print_json({'message': "Error: wrong format, needs: switch_name:new_state (on/off)"})
            sys.exit(2)

        target_devices = client.get_device_names_by_alias(target_light)
        for device in client.get_devices_by_name(target_light):
            target_devices.append(device['name'])

        for device in target_devices:
            client.cmd(device, new_state)
            current_state = 'on' if client.is_on(device) else 'off'
            print_json({'message': "%s is now %s" % (device, current_state)})
else:
    help()
    to_s(client)
