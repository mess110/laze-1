# arduino

Press a button from node.js using Arduino with the `firmata` protocol.

## Setup

```
npm install
```

## Using from raspberry pi

Add your user to the `dialout` group so you can connect to the Arduino. You will
need to relog for the changes to take effect.

```shell
sudo usermod -a -G dialout yourUsername
sudo reboot
```

Print the [Universal "Button pusher" SG90](https://www.thingiverse.com/thing:2806324),
connect the data line from the servo to pin **9**.

To trigger a press, run the `press` script. It handles mutex.

```
npm install
./press
./press 90 140
```
