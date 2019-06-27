from sonoff import Sonoff, SonoffException


class Api:
    def __init__(self, config):
        self.config = config
        self.sonoff = Sonoff(config.username, config.password, config.api_region, config.user_apikey, config.bearer_token)


    def credentials(self):
        return self.sonoff.get_user_apikey(), self.sonoff.get_bearer_token()


    def get_devices(self):
        return self.sonoff.get_devices()


    def get_devices_by_id(self, id):
        return [x for x in self.get_devices() if x['deviceid'] == id]


    def get_devices_by_name(self, name):
        return [x for x in self.get_devices() if x['name'] == name]


    def get_devices_by_alias(self, alias):
        results = []

        for key in self.config.aliases:
            if key == alias:
                for item in self.config.aliases[alias]:
                    results.append(item)

        return results


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


    def info(self):
        results = []
        for device in self.get_devices():
            results.append({
                "deviceid": device['deviceid'],
                "on": self.is_on(device['name']),
                "name": device['name'],
            })
        return results
