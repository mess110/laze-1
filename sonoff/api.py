from sonoff import Sonoff

class Api:
    def __init__(self, config):
        self.sonoff = Sonoff(config['username'], config['password'], config['api_region'], config['user_apikey'], config['bearer_token'])


    def credentials(self):
        return self.sonoff.get_user_apikey(), self.sonoff.get_bearer_token()


    def get_devices(self):
        devices = self.sonoff.get_devices()
        result = []
        if not devices:
            return result

        for device in devices:
            result.append({
                'name': device['name'],
                'id': device['deviceid'],
                'on': device['params']['switch'] == 'on'
            })

        return result


    def toggle(self, name):
        devices = self.get_devices()
        found = False
        for device in devices:
            if device['name'] == name:
                found = True
                self.sonoff.switch(not device['on'], device['id'], None)
        return found
