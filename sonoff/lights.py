#!/usr/bin/env python3

import sys
import json

from api import Api
from config import Config
from sonoff import SonoffException

config = Config()
config.read_config()
config.load_aliases()

def to_s(client):
    print("")
    results = client.info()
    for result in results:
        print("  %s - %s" % (result['name'].ljust(10), result['on']))

def to_json(client):
    results = client.info()
    print('[')
    for result in results:
        print("  %s," % json.dumps(result))
    print(']')


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
        print("""lumina - sonoff remote control

Aliases can be found in ~/.sonoff-aliases and have the following format:

alias_name switch_1_name:on switch_2_name:on switch_3_name:on

Example usage:

./lumina
./lumina help
./lumina json
./lumina info
./lumina switch_name
./lumina switch_name:off
./lumina switch_alias
""")
    else:
        target_light = sys.argv[1]

        # hold the switch_name:new_state combo
        vect2d = target_light.split(':')

        if len(vect2d) == 2:
            target_light = vect2d[0]

        target_devices = client.get_devices_by_alias(target_light)

        if len(target_devices) == 0:
            # run a single command if no aliases found.
            # we assume the target_light is a valid switch_name
            if len(vect2d) == 1:
                client.toggle(target_light)
            else:
                target_light = vect2d[0]
                client.cmd(target_light, vect2d[1])
            print("%s is %s" % (target_light, client.is_on(target_light)))
        else:
            # run a command per each alias found
            for alias in target_devices:
                vect2d_device = alias.split(':')
                if len(vect2d) == 2:
                    # alias specified override with :new_state
                    client.cmd(vect2d_device[0], vect2d[1])
                else:
                    # use alias found in alias file or toggle
                    if len(vect2d_device) == 1:
                        # alias not specified state
                        state = client.config.aliases[target_light][alias]
                        if state is None or len(state) == 0:
                            client.toggle(alias)
                        else:
                            client.cmd(alias, state)
                    else:
                        # if alias file specified state use that
                        alias = vect2d_device[0]
                        client.cmd(alias, vect2d_device[1])

                print("%s is %s" % (alias, client.is_on(alias)))

else:
    to_s(client)
