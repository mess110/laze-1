from sonoff import Sonoff, SonoffException

import json

class Api:
    def __init__(self, config):
        self.config = config
        self.sonoff = Sonoff(config.username, config.password, config.api_region, config.user_apikey, config.bearer_token)


    def credentials(self):
        return self.sonoff.get_user_apikey(), self.sonoff.get_bearer_token()


    def get_devices(self):
        return self.sonoff.get_devices()


    def get_devices_by_name(self, name):
        result = []

        for device in self.get_devices():
            if device['name'] == name:
                result.append(device)

        return result


    def is_on(self, name):
        is_on = False
        for device in self.get_devices_by_name(name):
            if device['params']['switch'] == 'on':
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


    def to_json(self):
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
