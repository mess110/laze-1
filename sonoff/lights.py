#!/usr/bin/env python3

import os
import sys
import json

from getpass import getpass
from api import Api
from sonoff import SonoffException, HTTP_UNAUTHORIZED

path = os.path.expanduser('~/.sonoff-credentials')
tokens_exist = os.path.isfile(path)

config = {
    'username': None,
    'password': None,
    'api_region': 'eu',
    'user_apikey': None,
    'bearer_token': None,
    'aliases': [],
}

if tokens_exist:
    f = open(path, 'r')
    config_file = f.read().split('\n')
    config['user_apikey'] = config_file[0]
    config['bearer_token'] = config_file[1]
    config['aliases'] = [alias for alias in config_file[2:] if alias]
else:
    user = input('user/email/phone: ')
    config['username'] = user
    pwd = getpass('password: ')
    config['password'] = pwd

try:
    client = Api(config)
except SonoffException as e:
    print(e)
    sys.exit(1)

if not tokens_exist:
    user_apikey, bearer_token = client.credentials()

    f = open(path, 'w')
    f.write("%s\n%s" % (user_apikey, bearer_token))
    f.close()

if len(sys.argv) == 2:
    client.toggle(sys.argv[1])

client.print_devices()
