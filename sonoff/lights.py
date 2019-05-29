#!/usr/bin/env python3

import os
import sys

from getpass import getpass
from api import Api

path = os.path.expanduser('~/.sonoff-credentials')
tokens_exist = os.path.isfile(path)

config = {
    'username': '',
    'password': '',
    'api_region': 'eu',
    'user_apikey': '',
    'bearer_token': '',
}

if tokens_exist:
    f = open(path, 'r')
    user_apikey, bearer_token = f.read().split()
    config['user_apikey'] = user_apikey
    config['bearer_token'] = bearer_token
else:
    user = input('user/email/phone: ')
    config['username'] = user
    pwd = getpass('password: ')
    config['password'] = pwd

client = Api(config)

# TODO: implement remove path when login failed

if not tokens_exist:
    user_apikey, bearer_token = client.credentials()

    f = open(path, 'w')
    f.write("%s\n%s" % (user_apikey, bearer_token))
    f.close()

if len(sys.argv) == 1:
    print(client.get_devices())
else:
    if len(sys.argv) != 2:
        print('missing switch name')
        sys.exit(1)

    client.toggle(sys.argv[1])
