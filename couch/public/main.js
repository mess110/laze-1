// Config.instance.window.showStatsOnStart = true
// Config.instance.engine.debug = true
Utils.orientation('landscape')

let socket = null
let connectingScene = new ConnectingScene()
let gamepad1ButtonScene = new Gamepad1ButtonScene()

Engine.start(connectingScene, [
  { type: 'font', path: 'assets/luckiest-guy' },
  { type: 'image', path: 'assets/logo.png' },
])
