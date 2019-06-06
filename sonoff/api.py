from sonoff import Sonoff, SonoffException

import json

class Api:
    def __init__(self, config):
        self.sonoff = Sonoff(config['username'], config['password'], config['api_region'], config['user_apikey'], config['bearer_token'])
        self.aliases = config['aliases']


    def credentials(self):
        return self.sonoff.get_user_apikey(), self.sonoff.get_bearer_token()


    def get_devices(self):
        return self.sonoff.get_devices()


    def get_devices_by_name(self, name):
        result = []
        name_array = [name]

        for alias in self.aliases:
            alias_array = alias.split(' ')
            if alias_array[0] == name:
                alias_array = alias_array[1:]
                for a in alias_array:
                    name_array.append(a)

        for device in self.get_devices():
            if device['name'] in name_array:
                result.append(device)

        return result


    def is_on(self, name):
        if not isinstance(name, str):
            raise SonoffException('name must be a string')

        is_on = False
        for device in self.get_devices_by_name(name):
            if name == device['name'] and device['params']['switch'] == 'on':
                is_on = True

        return is_on


    def toggle(self, name):
        self.cmd(name, not self.is_on(name))


    def on(self, name):
        self.cmd(name, True)


    def off(self, name):
        self.cmd(name, False)


    def cmd(self, name, on):
        for device in self.get_devices_by_name(name):
            self.sonoff.switch(on, device['deviceid'], None)


    def print_devices(self):
        results = []
        for device in self.get_devices():
            results.append({
                "deviceid": device['deviceid'],
                "on": self.is_on(device['name']),
                "name": device['name'],
            })
        print('[')
        for result in results:
            print("  %s," % json.dumps(result))
        print(']')
