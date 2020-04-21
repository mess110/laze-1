class ConnectingScene extends Scene {
  init(options) {
    let camera = Hodler.get('camera')
    camera.position.set(0, 4, 10)
    camera.lookAt(new THREE.Vector3(0,0,0))

    this.add(new THREE.AmbientLight(0xffffff))
    this.model = Utils.plane({ map: 'logo.png', width: 6, height: 6 })
    this.add(this.model)

    let text = new BaseText({
      text: 'connecting', fillStyle: 'white',
      strokeStyle: 'black', strokeLineWidth: 1,
      canvasW: 512, canvasH: 512, align: 'center',
      font: '74px luckiest-guy'})
    text.position.set(0, -0.5, 6)
    text.lookAt(Hodler.get('camera').position)
    this.add(text)

    socket = io(window.location.host)
    Engine.switch(gamepad1ButtonScene)
  }
}
