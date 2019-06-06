# sonoff

```
virtualenv -p python3 venv
source venv/bin/activate
pip install -r requirements.txt
./lights.py
./lights.py name1
```

Config is written in `~/.laze-sonoff`

You can create groups by appending new lines to the file:

```
user_apikey
bearer_token
alias_name1 light1_name light2_name
alias_name2 light2_name light3_name
```

After that you can call `./lights.py alias_name1` to toggle `light1_name` and `light2_name`
