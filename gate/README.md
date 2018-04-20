# gate

Press a button from node.js using Arduino with the `firmata` protocol.

Add your user to the `dialout` group so you can connect to the Arduino. You will
need to relog for the changes to take effect.

```shell
sudo usermod -a -G dialout yourUsername
sudo reboot
```

Print the [https://www.thingiverse.com/thing:2806324](Universal Button pusher for SG90),
connect the data line from the servo to pin **9**.

To trigger a press, run the `press` script. It handles mutex.

```shell
./press # default 90 140

./press 0 90
```
