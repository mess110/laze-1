import os

from getpass import getpass

VERSION = '0.0.1'

class Config():
    def __init__(self):
        self.config_path = '~/.sonoff-credentials'
        self.aliases_path = '~/.sonoff-aliases'

        self.username = None
        self.password = None
        self.api_region = 'eu'
        self.user_apikey = None
        self.bearer_token = None
        self.aliases_raw = []
        self.aliases = {}


    def load_aliases(self):
        path = os.path.expanduser(self.aliases_path)
        path_exists = os.path.isfile(path)

        if path_exists:
            f = open(path, 'r')
            self.aliases_raw = f.read().split('\n')

        self.parse_aliases()


    def parse_aliases(self):
        for alias in self.aliases_raw:
            aliases_array = alias.split(' ')
            key = aliases_array.pop(0)
            self.aliases[key] = aliases_array


    def read_config(self):
        path = os.path.expanduser(self.config_path)
        path_exists = os.path.isfile(path)

        if path_exists:
            f = open(path, 'r')
            config_file = f.read().split('\n')
            self.user_apikey = config_file[0]
            self.bearer_token = config_file[1]
        else:
            user = input('user/email/phone: ')
            self.username = user
            pwd = getpass('password: ')
            self.password = pwd


    def save_api_key_and_bearer(self, credentials):
        path = os.path.expanduser(self.config_path)
        path_exists = os.path.isfile(path)

        if path_exists:
            return

        user_apikey, bearer_token = credentials

        f = open(path, 'w')
        f.write("%s\n%s" % (user_apikey, bearer_token))
        f.close()
