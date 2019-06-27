# laze-1

A collection of automation things. It can:

* [pay the bills](/girbot) [(with sms confirmation code forwarding)](/laze)
* [control the lights](/sonoff)
* [talk using google tts](/README.md#tts)
* [raspberry pi setup](/raspberry)

## Basic setup

You need to have the enviornment variable `LAZE_PATH` configured:

```
export LAZE_PATH="$HOME/laze-1"
```

In this example, I assume you cloned `laze-1` in your `$HOME` directory.

## tts

Text to speach is done through Google using the [tts](/api/tts) script.
Example usage:

```
tts [language] [volume] [text]

tts ro 100 salutare lume
tts en 50 hello world
```
