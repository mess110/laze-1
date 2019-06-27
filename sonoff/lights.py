#!/usr/bin/env python3

import sys

from api import Api
from config import Config
from sonoff import SonoffException

config = Config()
config.read_config()
config.load_aliases()

try:
    client = Api(config)
except SonoffException as e:
    print(e)
    sys.exit(1)

config.save_api_key_and_bearer(client.credentials())

if len(sys.argv) == 2:
    client.toggle(sys.argv[1])

client.to_json()
